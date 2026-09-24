#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=capacity; DEP=load-planner

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found"; exit 1; }
spec=$(echo "$json" | jq -r '.spec.replicas')
[ "$spec" = "3" ] || { echo "FAIL: $DEP must keep 3 replicas (spec.replicas=$spec)"; exit 1; }
gen=$(echo "$json" | jq -r '.metadata.generation'); obs=$(echo "$json" | jq -r '.status.observedGeneration // 0')
upd=$(echo "$json" | jq -r '.status.updatedReplicas // 0')
rdy=$(echo "$json" | jq -r '.status.readyReplicas // 0')
tot=$(echo "$json" | jq -r '.status.replicas // 0')
if [ "$obs" -lt "$gen" ] || [ "$upd" != "3" ] || [ "$rdy" != "3" ] || [ "$tot" != "3" ]; then
  echo "FAIL: $DEP is not fully rolled out (updated=$upd ready=$rdy total=$tot)"
  exit 1
fi
pending=$(kubectl -n "$NS" get pods -l app=load-planner -o json | jq '[.items[] | select(.metadata.deletionTimestamp == null) | select(.status.phase=="Pending")] | length')
[ "$pending" = "0" ] || { echo "FAIL: $pending $DEP Pod(s) are still Pending"; exit 1; }
echo "PASS: all 3 $DEP replicas are scheduled and Ready"
exit 0
