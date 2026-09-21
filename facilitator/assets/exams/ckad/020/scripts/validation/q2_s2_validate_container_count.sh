#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c_count=$(kubectl get pod data-transformer -n origin -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$c_count" -ge 2 ]; then
  echo "Success: pod has $c_count containers"
  exit 0
fi
echo "Error: pod has $c_count containers, expected at least 2"
exit 1
