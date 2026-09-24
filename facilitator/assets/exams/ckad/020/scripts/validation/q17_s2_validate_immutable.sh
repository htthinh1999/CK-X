#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
im=$(kubectl get secret static-creds -n primal -o jsonpath='{.immutable}' 2>/dev/null)
if [ "$im" = "true" ]; then
  echo "Success: secret static-creds is immutable"
  exit 0
fi
echo "Error: secret static-creds immutable is '$im', expected true"
exit 1
