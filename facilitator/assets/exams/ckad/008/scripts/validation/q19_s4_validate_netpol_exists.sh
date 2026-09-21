#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get networkpolicy web-policy -n mist >/dev/null 2>&1; then
  echo "Success: networkpolicy web-policy exists"; exit 0
else
  echo "Error: networkpolicy web-policy not found"; exit 1
fi
