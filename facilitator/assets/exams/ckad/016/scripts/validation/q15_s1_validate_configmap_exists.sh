#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get configmap app-args -n voltage >/dev/null 2>&1; then
  echo "Success: configmap app-args exists"; exit 0
fi
echo "Error: configmap app-args not found in voltage"; exit 1
