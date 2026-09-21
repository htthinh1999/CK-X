#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get deploy prod-web-app -n zenith -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$r" = "3" ]; then
  echo "Success: replicas is 3"
  exit 0
else
  echo "Error: replicas is '$r' (expected 3)"
  exit 1
fi
