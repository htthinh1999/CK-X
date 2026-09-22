#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get cm app-config-dir -n tide >/dev/null 2>&1; then
  echo "Success: configmap app-config-dir exists in tide"; exit 0
fi
echo "Error: configmap app-config-dir not found in tide"; exit 1
