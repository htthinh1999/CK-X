#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
y=$(kubectl get networkpolicy api-allow -n sunbeam -o yaml 2>/dev/null)
if echo "$y" | grep -q "role: frontend"; then
  echo "Success: has podSelector rule role=frontend"
  exit 0
else
  echo "Error: missing podSelector rule role=frontend"
  exit 1
fi
