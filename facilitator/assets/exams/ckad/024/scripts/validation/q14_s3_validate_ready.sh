#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
res=$(kubectl -n gatehouse get deployment boom-gate -o json 2>/dev/null \
  | jq -r '[(.status.updatedReplicas // 0), (.status.readyReplicas // 0), (.status.availableReplicas // 0)] | map(tostring) | join(" ")')
if [ "$res" = "3 3 3" ]; then
  echo "OK: all 3 boom-gate replicas are updated, ready and available"
  exit 0
fi
echo "FAIL: updated/ready/available = '${res:-none}' (expected 3 3 3)"
exit 1
