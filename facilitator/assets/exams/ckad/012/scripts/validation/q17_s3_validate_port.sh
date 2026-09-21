#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get service backend-svc -n gate -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$val" = "80" ]; then
  echo "Success: Service port ($val)"
  exit 0
else
  echo "Error: Service port - got '$val', expected '80'"
  exit 1
fi
