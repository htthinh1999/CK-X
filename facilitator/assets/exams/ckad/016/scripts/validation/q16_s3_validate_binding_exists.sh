#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get clusterrolebinding secret-reader-binding >/dev/null 2>&1; then
  echo "Success: clusterrolebinding secret-reader-binding exists"; exit 0
fi
echo "Error: clusterrolebinding secret-reader-binding not found"; exit 1
