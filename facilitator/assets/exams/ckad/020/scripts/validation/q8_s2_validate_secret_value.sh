#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get secret matrix-secret -n matrix -o jsonpath='{.data.db-password}' 2>/dev/null | base64 -d 2>/dev/null)
if [ "$val" = "supersecret" ]; then
  echo "Success: db-password is supersecret"
  exit 0
fi
echo "Error: db-password is '$val', expected supersecret"
exit 1
