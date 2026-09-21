#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get rolebinding master-binding -n pinnacle >/dev/null 2>&1; then
  echo "Success: rolebinding master-binding exists in pinnacle"
  exit 0
fi
echo "Error: rolebinding master-binding not found in pinnacle"
exit 1
