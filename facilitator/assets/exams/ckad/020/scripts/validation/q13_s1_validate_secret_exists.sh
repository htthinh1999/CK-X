#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get secret static-creds -n primal >/dev/null 2>&1; then
  echo "Success: secret static-creds exists in primal"
  exit 0
fi
echo "Error: secret static-creds not found in primal"
exit 1
