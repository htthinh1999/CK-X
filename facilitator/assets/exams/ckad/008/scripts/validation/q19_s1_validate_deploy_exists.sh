#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get deployment web -n mist >/dev/null 2>&1; then
  echo "Success: deployment web exists"; exit 0
else
  echo "Error: deployment web not found"; exit 1
fi
