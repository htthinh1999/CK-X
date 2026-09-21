#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
replicas=$(kubectl get deployment fire-app -n blaze -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$replicas" = "3" ]; then
  echo "Success: 3 replicas"
  exit 0
else
  echo "Error: replicas is '$replicas', expected 3"
  exit 1
fi
