#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
c=$(kubectl get pod data-transform -n phoenix -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$c" = "2" ]; then
  echo "Success: 2 containers"
  exit 0
else
  echo "Error: container count is '$c', expected 2"
  exit 1
fi
