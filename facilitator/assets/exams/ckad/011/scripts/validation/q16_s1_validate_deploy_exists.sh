#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment web-deploy -n tide >/dev/null 2>&1; then
  echo "Success: Deployment web-deploy exists in tide"
  exit 0
else
  echo "Error: Deployment web-deploy not found in tide"
  exit 1
fi
