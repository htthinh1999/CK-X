#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# Rollback finished: 3 desired, 3 updated, 3 ready, no leftover (stuck) pods.
json=$(kubectl -n quayside get deployment crane -o json 2>/dev/null)
[ -z "$json" ] && { echo "FAIL: deployment crane not found"; exit 1; }
res=$(echo "$json" | jq -r '[
  (.spec.replicas // 0),
  (.status.replicas // 0),
  (.status.updatedReplicas // 0),
  (.status.readyReplicas // 0),
  (.status.availableReplicas // 0),
  (.status.unavailableReplicas // 0),
  (if (.status.observedGeneration // 0) >= .metadata.generation then 1 else 0 end)
] | map(tostring) | join(" ")')
if [ "$res" = "3 3 3 3 3 0 1" ]; then
  echo "OK: crane has 3/3 updated and ready replicas"
  exit 0
fi
echo "FAIL: spec/total/updated/ready/available/unavailable/observed = $res (expected 3 3 3 3 3 0 1)"
exit 1
