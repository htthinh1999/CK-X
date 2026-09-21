#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get role pod-reader-role -n bastion >/dev/null 2>&1; then
  echo "Success: Role pod-reader-role exists in bastion"
  exit 0
else
  echo "Error: Role pod-reader-role exists in bastion - not found"
  exit 1
fi
