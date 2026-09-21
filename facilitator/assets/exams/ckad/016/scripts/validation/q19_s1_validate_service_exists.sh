#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service sticky-svc -n flash >/dev/null 2>&1; then
  echo "Success: service sticky-svc exists"; exit 0
fi
echo "Error: service sticky-svc not found in flash"; exit 1
