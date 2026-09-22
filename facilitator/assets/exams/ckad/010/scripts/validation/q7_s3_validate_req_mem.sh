#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get quota compute-quota -n fortune -o jsonpath='{.spec.hard.requests\.memory}' 2>/dev/null)
if [ "$val" = "1Gi" ]; then
  echo "Success: requests.memory is 1Gi"
  exit 0
else
  echo "Error: requests.memory incorrect (got '$val')"
  exit 1
fi
