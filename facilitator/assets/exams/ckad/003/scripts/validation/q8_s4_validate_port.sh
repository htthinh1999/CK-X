#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
p=$(kubectl get service backend-headless -n corona -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$p" = "80" ]; then
  echo "Success: port 80"
  exit 0
else
  echo "Error: port is '$p', expected 80"
  exit 1
fi
