#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get netpol deny-all -n trench >/dev/null 2>&1; then
  echo "Success: networkpolicy deny-all exists in trench"; exit 0
fi
echo "Error: networkpolicy deny-all not found in trench"; exit 1
