#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
containers=$(kubectl get pod tri-blade -n summit -o jsonpath='{.spec.containers[*].name}' 2>/dev/null)
if [[ "$containers" == *"main"* && "$containers" == *"sidecar"* && "$containers" == *"adapter"* ]]; then
  echo "Success: containers main, sidecar and adapter present"
  exit 0
fi
echo "Error: containers mismatch, got '$containers'"
exit 1
