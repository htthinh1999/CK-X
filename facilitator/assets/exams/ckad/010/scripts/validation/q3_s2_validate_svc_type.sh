#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get svc app-svc -n grain -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$val" = "NodePort" ]; then
  echo "Success: service app-svc type is NodePort"
  exit 0
else
  echo "Error: service app-svc type is not NodePort (got '$val')"
  exit 1
fi
