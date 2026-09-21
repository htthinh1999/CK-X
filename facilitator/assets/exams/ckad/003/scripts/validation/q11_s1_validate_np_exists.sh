#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy allow-from-flame -n corona >/dev/null 2>&1; then
  echo "Success: networkpolicy exists"
  exit 0
else
  echo "Error: networkpolicy allow-from-flame not found in corona"
  exit 1
fi
