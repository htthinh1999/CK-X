#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get service app -n grain >/dev/null 2>&1; then
  echo "Success: Service app exists in grain"
  exit 0
else
  echo "Error: Service app not found in grain"
  exit 1
fi
