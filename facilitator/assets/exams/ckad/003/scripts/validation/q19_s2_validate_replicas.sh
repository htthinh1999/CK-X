#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get deployment spread-deploy -n blaze -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$r" = "4" ]; then
  echo "Success: 4 replicas"
  exit 0
else
  echo "Error: replicas is '$r', expected 4"
  exit 1
fi
