#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get configmap app-config -n gate >/dev/null 2>&1; then
  echo "Success: ConfigMap app-config exists in gate"
  exit 0
else
  echo "Error: ConfigMap app-config exists in gate - not found"
  exit 1
fi
