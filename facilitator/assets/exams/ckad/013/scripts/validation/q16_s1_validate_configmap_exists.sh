#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get configmap app-config -n eclipse >/dev/null 2>&1; then
  echo "Success: ConfigMap app-config exists"
  exit 0
else
  echo "Error: ConfigMap app-config not found"
  exit 1
fi
