#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get configmap env-config -n voyage >/dev/null 2>&1; then
  echo "Success: ConfigMap env-config exists in voyage"
  exit 0
else
  echo "Error: ConfigMap env-config not found in voyage"
  exit 1
fi
