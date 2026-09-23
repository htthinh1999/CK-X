#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=kiosk

kubectl -n "$NS" get networkpolicy kiosk-ingress >/dev/null 2>&1 || { echo "ERR: NetworkPolicy kiosk-ingress not found in $NS"; exit 1; }
nps=$(kubectl -n "$NS" get networkpolicy -o json 2>/dev/null | jq -c '[.items[] | {name: .metadata.name, spec: .spec}]')
tmpl=$(kubectl -n "$NS" get deployment kiosk -o json 2>/dev/null | jq -c '.spec.template.metadata.labels // {}')
[ -n "$tmpl" ] && [ "$tmpl" != "{}" ] || { echo "ERR: Deployment kiosk not found"; exit 1; }
# the labels must stay as they are (removing tier=frontend would dodge the existing policy)
echo "$tmpl" | jq -e '.app == "kiosk" and .tier == "frontend"' >/dev/null 2>&1 \
  || { echo "ERR: the Pod labels of Deployment kiosk were changed ($tmpl), app=kiosk and tier=frontend must stay"; exit 1; }
nsl=$(kubectl get namespace kiosk ops-east ops-west -o json 2>/dev/null | jq -cS '[.items[] | {(.metadata.name): (.metadata.labels.team // "")}] | add')
[ "$nsl" = '{"kiosk":"","ops-east":"ops","ops-west":"dev"}' ] \
  || { echo "ERR: namespace labels were changed (team labels: $nsl), expected ops-east team=ops, ops-west team=dev, kiosk none"; exit 1; }

# Evaluate the union of all policies that select the kiosk Pods for a set of
# representative sources (expected: TCP 80 allowed or not; 8081 never allowed)
srcs='[
 {"d":"ops-east role=monitor",          "ns":"ops-east",  "nsl":{"kubernetes.io/metadata.name":"ops-east","team":"ops"},  "pl":{"role":"monitor"},              "p80":true},
 {"d":"another team=ops ns role=monitor","ns":"ops-north","nsl":{"kubernetes.io/metadata.name":"ops-north","team":"ops"},"pl":{"role":"monitor","app":"probe"}, "p80":true},
 {"d":"kiosk ns kiosk-client",          "ns":"kiosk",     "nsl":{"kubernetes.io/metadata.name":"kiosk"},                   "pl":{"app":"kiosk-client"},          "p80":true},
 {"d":"kiosk ns unlabeled pod",         "ns":"kiosk",     "nsl":{"kubernetes.io/metadata.name":"kiosk"},                   "pl":{},                              "p80":true},
 {"d":"kiosk ns role=guest",            "ns":"kiosk",     "nsl":{"kubernetes.io/metadata.name":"kiosk"},                   "pl":{"role":"guest"},                "p80":true},
 {"d":"ops-east role=guest",            "ns":"ops-east",  "nsl":{"kubernetes.io/metadata.name":"ops-east","team":"ops"},  "pl":{"role":"guest"},                "p80":false},
 {"d":"ops-east unlabeled pod",         "ns":"ops-east",  "nsl":{"kubernetes.io/metadata.name":"ops-east","team":"ops"},  "pl":{},                              "p80":false},
 {"d":"ops-west (team=dev) role=monitor","ns":"ops-west", "nsl":{"kubernetes.io/metadata.name":"ops-west","team":"dev"},  "pl":{"role":"monitor"},              "p80":false},
 {"d":"ops-west role=guest",            "ns":"ops-west",  "nsl":{"kubernetes.io/metadata.name":"ops-west","team":"dev"},  "pl":{"role":"guest"},                "p80":false},
 {"d":"default ns role=monitor",        "ns":"default",   "nsl":{"kubernetes.io/metadata.name":"default"},                 "pl":{"role":"monitor"},              "p80":false},
 {"d":"team=ops-tools ns role=monitor", "ns":"tooling",   "nsl":{"kubernetes.io/metadata.name":"tooling","team":"ops-tools"},"pl":{"role":"monitor"},           "p80":false},
 {"d":"team=dev ns app=kiosk",          "ns":"kiosk-lab", "nsl":{"kubernetes.io/metadata.name":"kiosk-lab","team":"dev"}, "pl":{"app":"kiosk","tier":"frontend"},"p80":false}
]'

res=$(jq -rn --argjson nps "$nps" --argjson tl "$tmpl" --argjson srcs "$srcs" --arg pns "$NS" '
  def selmatch($sel; $l):
    ((($sel.matchLabels // {}) | to_entries) | all(. as $e | $l[$e.key] == $e.value))
    and ((($sel.matchExpressions // [])) | all(. as $x |
      if $x.operator == "In" then ($l | has($x.key)) and ((($x.values // []) | index($l[$x.key])) != null)
      elif $x.operator == "NotIn" then (($l | has($x.key)) | not) or ((($x.values // []) | index($l[$x.key])) == null)
      elif $x.operator == "Exists" then ($l | has($x.key))
      elif $x.operator == "DoesNotExist" then (($l | has($x.key)) | not)
      else false end));
  def peermatch($p; $s):
    if $p.ipBlock != null then true
    else (if $p.namespaceSelector != null then selmatch($p.namespaceSelector; $s.nsl) else ($s.ns == $pns) end)
         and (if $p.podSelector != null then selmatch($p.podSelector; $s.pl) else true end)
    end;
  def portmatch($ports; $port; $pname):
    ($ports == null) or (($ports | length) == 0)
    or ($ports | any(. as $q | (($q.protocol // "TCP") == "TCP") and (
          ($q.port == null)
          or ($q.port == $port)
          or ((($q.port | type) == "string") and ($q.port == $pname))
          or ((($q.port | type) == "number") and ($q.endPort != null) and ($q.port <= $port) and ($port <= $q.endPort)))));
  def allowed($s; $port; $pname):
    [$nps[] | select(selmatch(.spec.podSelector // {}; $tl))
            | select((.spec.policyTypes // ["Ingress"]) | index("Ingress") != null)] as $app
    | if ($app | length) == 0 then true
      else [$app[] | (.spec.ingress // [])[]
             | select((.from == null) or ((.from | length) == 0) or (. as $r | $r.from | any(peermatch(.; $s))))
             | select(portmatch(.ports; $port; $pname))] | length > 0
      end;
  [ $srcs[]
    | . as $s
    | (allowed($s; 80; "http")) as $a80
    | (allowed($s; 8081; "metrics")) as $a8081
    | (if $a80 != $s.p80 then "\($s.d): TCP 80 \(if $a80 then "allowed" else "denied" end), expected \(if $s.p80 then "allowed" else "denied" end)" else empty end),
      (if $a8081 then "\($s.d): TCP 8081 allowed, expected denied" else empty end)
  ] | if length == 0 then "OK" else "ERR: " + join("; ") end')

[ "$res" = "OK" ] || { echo "$res (policies in $NS: $(echo "$nps" | jq -r '[.[].name] | join(",")'))"; exit 1; }
echo "OK: policies in $NS allow TCP 80 only from team=ops/role=monitor Pods and from namespace kiosk"
exit 0
