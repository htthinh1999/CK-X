#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get ingress frontend-ingress -n bastion -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
if [ "$val" = "frontend-svc" ]; then
  echo "Success: Backend service name ($val)"
  exit 0
else
  echo "Error: Backend service name - got '$val', expected 'frontend-svc'"
  exit 1
fi
