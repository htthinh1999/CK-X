#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get rolebinding pod-reader-binding -n bastion >/dev/null 2>&1; then
  echo "Success: RoleBinding pod-reader-binding exists in bastion"
  exit 0
else
  echo "Error: RoleBinding pod-reader-binding exists in bastion - not found"
  exit 1
fi
