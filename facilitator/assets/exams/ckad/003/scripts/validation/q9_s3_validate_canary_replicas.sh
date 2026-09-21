#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get deployment canary-v2 -n blaze -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$r" = "1" ]; then
  echo "Success: canary has 1 replica"
  exit 0
else
  echo "Error: canary replicas is '$r', expected 1"
  exit 1
fi
