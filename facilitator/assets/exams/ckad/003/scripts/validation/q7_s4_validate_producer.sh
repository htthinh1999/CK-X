#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
n=$(kubectl get pod data-transform -n phoenix -o jsonpath='{.spec.containers[?(@.name=="producer")].name}' 2>/dev/null)
if [ "$n" = "producer" ]; then
  echo "Success: producer container exists"
  exit 0
else
  echo "Error: producer container not found"
  exit 1
fi
