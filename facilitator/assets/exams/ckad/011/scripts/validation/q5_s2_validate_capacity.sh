#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
capacity=$(kubectl get pv sea-pv -o jsonpath='{.spec.capacity.storage}' 2>/dev/null)
if [ "$capacity" = "5Gi" ]; then
  echo "Success: capacity is 5Gi"
  exit 0
else
  echo "Error: capacity is '$capacity', expected 5Gi"
  exit 1
fi
