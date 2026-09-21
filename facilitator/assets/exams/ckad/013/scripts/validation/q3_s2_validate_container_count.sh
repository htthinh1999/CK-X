#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c=$(kubectl get pod web-with-sidecar -n corona -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$c" -ge 2 ]; then
  echo "Success: pod has $c containers"
  exit 0
else
  echo "Error: pod has $c containers (expected >=2)"
  exit 1
fi
