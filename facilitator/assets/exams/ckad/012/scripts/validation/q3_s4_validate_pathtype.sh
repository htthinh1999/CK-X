#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get ingress api-ingress -n citadel -o jsonpath='{.spec.rules[0].http.paths[0].pathType}' 2>/dev/null)
if [ "$val" = "Prefix" ]; then
  echo "Success: PathType ($val)"
  exit 0
else
  echo "Error: PathType - got '$val', expected 'Prefix'"
  exit 1
fi
