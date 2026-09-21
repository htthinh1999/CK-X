#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
adapter=$(kubectl get pod wind-logger -n gale -o jsonpath='{.spec.containers[?(@.name=="adapter")].name}' 2>/dev/null)
if [ "$adapter" == "adapter" ]; then
  echo "Success: adapter container present in wind-logger"
  exit 0
else
  echo "Error: adapter container not found in pod wind-logger (gale)"
  exit 1
fi
