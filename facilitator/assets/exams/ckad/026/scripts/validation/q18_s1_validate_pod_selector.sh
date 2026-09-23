#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=kiosk; NP=kiosk-ingress

np=$(kubectl -n "$NS" get networkpolicy "$NP" -o json 2>/dev/null) || { echo "ERR: NetworkPolicy $NP not found in $NS"; exit 1; }
echo "$np" | jq -e '(.spec.policyTypes // ["Ingress"]) | index("Ingress") != null' >/dev/null || { echo "ERR: $NP does not have policy type Ingress"; exit 1; }

pods=$(kubectl -n "$NS" get pods -o json 2>/dev/null | jq -c '[.items[] | select(.metadata.deletionTimestamp == null) | {name: .metadata.name, labels: (.metadata.labels // {})}]')
tmpl=$(kubectl -n "$NS" get deployment kiosk -o json 2>/dev/null | jq -c '.spec.template.metadata.labels // {}')
[ -n "$tmpl" ] && [ "$tmpl" != "{}" ] || { echo "ERR: Deployment kiosk not found"; exit 1; }

res=$(jq -rn --argjson np "$np" --argjson pods "$pods" --argjson tmpl "$tmpl" '
  def selmatch($sel; $l):
    ((($sel.matchLabels // {}) | to_entries) | all(. as $e | $l[$e.key] == $e.value))
    and ((($sel.matchExpressions // [])) | all(. as $x |
      if $x.operator == "In" then ($l | has($x.key)) and ((($x.values // []) | index($l[$x.key])) != null)
      elif $x.operator == "NotIn" then (($l | has($x.key)) | not) or ((($x.values // []) | index($l[$x.key])) == null)
      elif $x.operator == "Exists" then ($l | has($x.key))
      elif $x.operator == "DoesNotExist" then (($l | has($x.key)) | not)
      else false end));
  ($np.spec.podSelector // {}) as $s
  | if (selmatch($s; $tmpl) | not) then "ERR: podSelector of kiosk-ingress does not select the Pods of Deployment kiosk"
    else
      ([$pods[] | select(selmatch($s; .labels)) | select((.labels.app // "") != "kiosk") | .name]) as $extra
      | if ($extra | length) > 0 then "ERR: podSelector of kiosk-ingress also selects other Pods: \($extra | join(", "))"
        else "OK" end
    end')
[ "$res" = "OK" ] || { echo "$res"; exit 1; }

echo "OK: $NP applies to the kiosk Pods only"
exit 0
