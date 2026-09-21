#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get ingress frontend-ingress -n bastion -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
if [ "$val" = "80" ]; then
  echo "Success: Backend service port ($val)"
  exit 0
else
  echo "Error: Backend service port - got '$val', expected '80'"
  exit 1
fi
