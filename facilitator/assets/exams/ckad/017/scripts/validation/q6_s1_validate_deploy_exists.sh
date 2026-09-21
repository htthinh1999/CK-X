#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deploy web-deploy -n reef >/dev/null 2>&1; then
  echo "Success: deployment web-deploy exists in reef"; exit 0
fi
echo "Error: deployment web-deploy not found in reef"; exit 1
