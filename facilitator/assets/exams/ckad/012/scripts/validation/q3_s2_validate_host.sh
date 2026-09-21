#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get ingress api-ingress -n citadel -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ "$val" = "api.example.com" ]; then
  echo "Success: Ingress host ($val)"
  exit 0
else
  echo "Error: Ingress host - got '$val', expected 'api.example.com'"
  exit 1
fi
