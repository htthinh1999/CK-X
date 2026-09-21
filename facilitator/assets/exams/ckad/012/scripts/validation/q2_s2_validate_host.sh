#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get ingress frontend-ingress -n bastion -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ "$val" = "frontend.example.com" ]; then
  echo "Success: Ingress host ($val)"
  exit 0
else
  echo "Error: Ingress host - got '$val', expected 'frontend.example.com'"
  exit 1
fi
