#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get deploy -n radiance -l app.kubernetes.io/instance=web-release -o jsonpath='{.items[0].spec.replicas}' 2>/dev/null)
if [ "$r" = "3" ]; then
  echo "Success: replicas is 3"
  exit 0
else
  echo "Error: replicas is '$r' (expected 3)"
  exit 1
fi
