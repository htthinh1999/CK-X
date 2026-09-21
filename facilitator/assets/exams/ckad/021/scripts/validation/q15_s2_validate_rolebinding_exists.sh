#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get rolebinding dev-config-binding -n haven >/dev/null 2>&1; then
  echo "Success: rolebinding dev-config-binding exists in haven"
  exit 0
fi
echo "Error: rolebinding dev-config-binding missing in haven"
exit 1
