#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
req=$(kubectl get pod qos-guaranteed -n spark -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
lim=$(kubectl get pod qos-guaranteed -n spark -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)
if [ "$req" = "$lim" ] && [ -n "$req" ]; then
  echo "Success: memory requests = limits ($req)"
  exit 0
else
  echo "Error: memory requests ('$req') != limits ('$lim')"
  exit 1
fi
