#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
count=$(kubectl get pod sidecar-pod -n abyss -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$count" -ge 2 ] 2>/dev/null; then
  echo "Success: Pod has $count containers"
  exit 0
else
  echo "Error: Pod has $count container(s), expected 2"
  exit 1
fi
