#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
h=$(kubectl get ingress secure-ingress -n solstice -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ "$h" = "secure.example.com" ]; then
  echo "Success: rule host secure.example.com"
  exit 0
else
  echo "Error: rule host is '$h'"
  exit 1
fi
