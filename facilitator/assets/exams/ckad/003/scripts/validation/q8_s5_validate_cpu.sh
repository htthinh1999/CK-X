#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
req=$(kubectl get pod qos-guaranteed -n spark -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
lim=$(kubectl get pod qos-guaranteed -n spark -o jsonpath='{.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
if [ "$req" = "$lim" ] && [ -n "$req" ]; then
  echo "Success: cpu requests = limits ($req)"
  exit 0
else
  echo "Error: cpu requests ('$req') != limits ('$lim')"
  exit 1
fi
