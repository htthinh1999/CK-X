#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get hpa app-deploy -n root >/dev/null 2>&1; then
  echo "Success: hpa app-deploy exists in root"; exit 0
else
  echo "Error: hpa app-deploy not found in root"; exit 1
fi
