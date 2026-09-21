#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

v=$(kubectl get pod resource-pod -n cave -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
if [ "$v" = "100m" ]; then
  echo "Success: CPU request is 100m"; exit 0
else
  echo "Error: CPU request is '$v', expected 100m"; exit 1
fi
