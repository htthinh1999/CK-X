#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cn=$(kubectl get pod lifecycle-pod -n phoenix -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$cn" = "main" ]; then
  echo "Success: container main"
  exit 0
else
  echo "Error: container is '$cn', expected main"
  exit 1
fi
