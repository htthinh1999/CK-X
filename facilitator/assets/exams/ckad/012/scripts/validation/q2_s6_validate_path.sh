#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get ingress frontend-ingress -n bastion -o jsonpath='{.spec.rules[0].http.paths[0].path}' 2>/dev/null)
if [ "$val" = "/" ]; then
  echo "Success: Path ($val)"
  exit 0
else
  echo "Error: Path - got '$val', expected '/'"
  exit 1
fi
