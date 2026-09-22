#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
proj=$(kubectl get pod projected-pod -n origin -o jsonpath='{.spec.volumes[?(@.projected)].projected.sources}' 2>/dev/null)
if echo "$proj" | grep -q "downwardAPI"; then
  echo "Success: projected volume includes downwardAPI source"
  exit 0
fi
echo "Error: projected volume does not include downwardAPI source"
exit 1
