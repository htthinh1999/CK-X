#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get deployment pause-deploy -n bark >/dev/null 2>&1; then
  echo "Success: deployment pause-deploy exists in bark"; exit 0
else
  echo "Error: deployment pause-deploy not found in bark"; exit 1
fi
