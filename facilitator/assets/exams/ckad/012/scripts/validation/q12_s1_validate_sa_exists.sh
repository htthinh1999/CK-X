#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get serviceaccount pod-reader-sa -n bastion >/dev/null 2>&1; then
  echo "Success: ServiceAccount pod-reader-sa exists in bastion"
  exit 0
else
  echo "Error: ServiceAccount pod-reader-sa exists in bastion - not found"
  exit 1
fi
