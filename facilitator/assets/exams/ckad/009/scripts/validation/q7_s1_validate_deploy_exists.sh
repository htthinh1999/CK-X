#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get deployment app-deploy -n root >/dev/null 2>&1; then
  echo "Success: deployment app-deploy exists in root"; exit 0
else
  echo "Error: deployment app-deploy not found in root"; exit 1
fi
