#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=junction; DEP=junction-blue

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP must still exist"; exit 1; }
spec=$(echo "$json" | jq -r '.spec.replicas')
[ "$spec" = "0" ] || { echo "FAIL: $DEP must be scaled to 0 (spec.replicas=$spec)"; exit 1; }

left=$(kubectl -n "$NS" get pods -l app=junction,tier=web,slot=blue -o json | jq '[.items[] | select(.metadata.deletionTimestamp == null) | select(.status.phase=="Running" or .status.phase=="Pending")] | length')
[ "$left" = "0" ] || { echo "FAIL: $left blue Pod(s) are still running"; exit 1; }

echo "PASS: $DEP is kept with 0 replicas and no blue Pods run"
exit 0
