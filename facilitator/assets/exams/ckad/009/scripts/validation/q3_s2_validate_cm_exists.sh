#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get configmap file-config -n glade >/dev/null 2>&1; then
  echo "Success: configmap file-config exists in glade"; exit 0
else
  echo "Error: configmap file-config not found in glade"; exit 1
fi
