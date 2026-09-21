#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deploy app-deploy -n trench >/dev/null 2>&1; then
  echo "Success: deployment app-deploy exists in trench"; exit 0
fi
echo "Error: deployment app-deploy not found in trench"; exit 1
