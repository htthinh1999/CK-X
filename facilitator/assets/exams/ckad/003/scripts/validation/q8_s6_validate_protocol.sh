#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
pr=$(kubectl get service backend-headless -n corona -o jsonpath='{.spec.ports[0].protocol}' 2>/dev/null)
if [ "$pr" = "TCP" ]; then
  echo "Success: protocol TCP"
  exit 0
else
  echo "Error: protocol is '$pr', expected TCP"
  exit 1
fi
