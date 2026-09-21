#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get rolebinding breeze-manager-binding -n breeze >/dev/null 2>&1; then
  echo "Success: RoleBinding breeze-manager-binding exists in breeze"
  exit 0
else
  echo "Error: RoleBinding breeze-manager-binding not found in breeze"
  exit 1
fi
