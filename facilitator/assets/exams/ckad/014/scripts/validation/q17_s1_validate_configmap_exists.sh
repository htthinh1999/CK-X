#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get configmap static-config -n twilight >/dev/null 2>&1; then
  echo "Success: configmap static-config exists in twilight"
  exit 0
else
  echo "Error: configmap static-config not found in twilight"
  exit 1
fi
