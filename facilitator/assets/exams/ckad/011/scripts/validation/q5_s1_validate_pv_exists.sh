#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pv sea-pv >/dev/null 2>&1; then
  echo "Success: PersistentVolume sea-pv exists"
  exit 0
else
  echo "Error: PersistentVolume sea-pv not found"
  exit 1
fi
