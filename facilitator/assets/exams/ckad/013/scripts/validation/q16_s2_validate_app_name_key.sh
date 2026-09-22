#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get configmap app-config -n eclipse -o jsonpath='{.data.APP_NAME}' 2>/dev/null)
if [ -n "$v" ]; then
  echo "Success: ConfigMap has APP_NAME key"
  exit 0
else
  echo "Error: ConfigMap missing APP_NAME key"
  exit 1
fi
