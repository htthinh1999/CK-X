#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
k=$(kubectl get secret db-credentials -n magma -o jsonpath='{.data.password\.txt}' 2>/dev/null)
if [ -n "$k" ]; then
  echo "Success: key password.txt present"
  exit 0
else
  echo "Error: secret missing key password.txt"
  exit 1
fi
