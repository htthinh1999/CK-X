#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get sa vault-sa -n shield >/dev/null 2>&1; then
  echo "Success: serviceaccount vault-sa exists in shield"
  exit 0
fi
echo "Error: serviceaccount vault-sa missing in shield"
exit 1
