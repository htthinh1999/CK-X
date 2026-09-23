#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=junction; SVC=junction; DEP=junction-green

svc=$(kubectl -n "$NS" get service "$SVC" -o json 2>/dev/null) || { echo "FAIL: Service $SVC not found"; exit 1; }

sel=$(echo "$svc" | jq -c '.spec.selector // {} | to_entries | sort_by(.key) | from_entries')
[ "$sel" = '{"app":"junction","slot":"green","tier":"web"}' ] || { echo "FAIL: Service selector must be app=junction,slot=green,tier=web (got $sel)"; exit 1; }

ports=$(echo "$svc" | jq -c '[.spec.ports[] | {name, port, protocol, targetPort}]')
[ "$ports" = '[{"name":"http","port":80,"protocol":"TCP","targetPort":"http"}]' ] || { echo "FAIL: the Service ports were changed (got $ports)"; exit 1; }

# IPs of the Ready, non-terminating Pods that belong to junction-green
rs_names=$(kubectl -n "$NS" get rs -o json | jq -c --arg d "$DEP" '[.items[] | select(any(.metadata.ownerReferences[]?; .kind=="Deployment" and .name==$d)) | .metadata.name]')
want=$(kubectl -n "$NS" get pods -o json | jq -r --argjson r "${rs_names:-[]}" '
  .items[]
  | select(.metadata.deletionTimestamp == null)
  | select(any(.metadata.ownerReferences[]?; .kind=="ReplicaSet" and (.name | IN($r[]))))
  | select(any(.status.conditions[]?; .type=="Ready" and .status=="True"))
  | .status.podIP' | sort -u)
nwant=$(echo "$want" | grep -c .)
[ "$nwant" -ge 1 ] || { echo "FAIL: no Ready Pods of $DEP found"; exit 1; }

ep=$(kubectl -n "$NS" get endpoints "$SVC" -o json 2>/dev/null) || { echo "FAIL: Endpoints $SVC not found"; exit 1; }
got=$(echo "$ep" | jq -r '[.subsets[]?.addresses[]?.ip] | .[]' | sort -u)
eports=$(echo "$ep" | jq -r '[.subsets[]?.ports[]?.port] | unique | map(tostring) | join(",")')

if [ -z "$got" ]; then
  echo "FAIL: Service $SVC has no ready endpoints"
  exit 1
fi
if [ "$got" != "$want" ]; then
  echo "FAIL: endpoints of $SVC ($(echo $got)) are not exactly the $DEP Pods ($(echo $want))"
  exit 1
fi
[ "$eports" = "80" ] || { echo "FAIL: endpoints must use port 80 (got '$eports')"; exit 1; }

echo "PASS: $SVC selects slot=green and its endpoints are exactly the $nwant $DEP Pods on port 80"
exit 0
