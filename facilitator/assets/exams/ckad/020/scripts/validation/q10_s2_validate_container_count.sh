#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# count containers + native sidecars (init containers with restartPolicy: Always)
c_count=$(kubectl get pod data-transformer -n origin -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length' 2>/dev/null)
c_count=${c_count:-0}
if [ "$c_count" -ge 2 ]; then
  echo "Success: pod has $c_count containers"
  exit 0
fi
echo "Error: pod has $c_count containers, expected at least 2"
exit 1
