#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get rolebinding deploy-rb -n zenith >/dev/null 2>&1; then
  echo "Success: RoleBinding deploy-rb exists"
  exit 0
else
  echo "Error: RoleBinding deploy-rb not found"
  exit 1
fi
