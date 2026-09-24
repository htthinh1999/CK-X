#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=routes; SVC=prod-route-board; DEP=prod-route-board

svc=$(kubectl -n "$NS" get service "$SVC" -o json 2>/dev/null) || { echo "FAIL: Service $SVC not found in $NS"; exit 1; }
sel=$(echo "$svc" | jq -c '.spec.selector // {} | to_entries | sort_by(.key) | from_entries')
[ "$sel" = '{"app":"route-board","env":"prod"}' ] || { echo "FAIL: $SVC selector must be app=route-board,env=prod (got $sel)"; exit 1; }

rs=$(kubectl -n "$NS" get rs -o json | jq -c --arg d "$DEP" '[.items[] | select(any(.metadata.ownerReferences[]?; .kind=="Deployment" and .name==$d)) | .metadata.name]')
want=$(kubectl -n "$NS" get pods -o json | jq -r --argjson r "${rs:-[]}" '
  .items[]
  | select(.metadata.deletionTimestamp == null)
  | select(any(.metadata.ownerReferences[]?; .kind=="ReplicaSet" and (.name | IN($r[]))))
  | select(any(.status.conditions[]?; .type=="Ready" and .status=="True"))
  | .status.podIP' | sort -u)
got=$(kubectl -n "$NS" get endpoints "$SVC" -o json 2>/dev/null | jq -r '[.subsets[]?.addresses[]?.ip] | .[]' | sort -u)
n=$(echo "$got" | grep -c .)

[ -n "$got" ] || { echo "FAIL: $SVC has no ready endpoints"; exit 1; }
[ "$got" = "$want" ] || { echo "FAIL: endpoints of $SVC ($(echo $got)) are not exactly the $DEP Pods ($(echo $want))"; exit 1; }
[ "$n" = "3" ] || { echo "FAIL: $SVC must have 3 endpoints (got $n)"; exit 1; }
echo "PASS: $SVC selects only the 3 prod Pods"
exit 0
