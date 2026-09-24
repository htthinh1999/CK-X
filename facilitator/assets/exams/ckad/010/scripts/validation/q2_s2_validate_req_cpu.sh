#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get quota compute-quota -n fortune -o jsonpath='{.spec.hard.requests\.cpu}' 2>/dev/null)
if [ "$val" = "1" ]; then
  echo "Success: requests.cpu is 1"
  exit 0
else
  echo "Error: requests.cpu incorrect (got '$val')"
  exit 1
fi
