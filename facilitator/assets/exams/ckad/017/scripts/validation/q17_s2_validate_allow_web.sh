#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get netpol allow-web -n trench >/dev/null 2>&1; then
  echo "Success: networkpolicy allow-web exists in trench"; exit 0
fi
echo "Error: networkpolicy allow-web not found in trench"; exit 1
