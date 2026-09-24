#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get configmap app-config -n aegis >/dev/null 2>&1; then
  echo "Success: configmap app-config exists in aegis"
  exit 0
fi
echo "Error: configmap app-config missing in aegis"
exit 1
