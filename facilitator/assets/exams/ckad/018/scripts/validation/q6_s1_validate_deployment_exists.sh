#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment rolling-deploy -n sonata >/dev/null 2>&1; then
  echo "Success: deployment rolling-deploy exists"; exit 0
fi
echo "Error: deployment rolling-deploy not found in sonata"; exit 1
