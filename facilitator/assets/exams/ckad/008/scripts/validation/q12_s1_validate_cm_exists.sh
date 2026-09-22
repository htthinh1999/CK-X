#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get configmap app-config -n peak >/dev/null 2>&1; then
  echo "Success: configmap app-config exists"; exit 0
else
  echo "Error: configmap app-config not found"; exit 1
fi
