#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get secret matrix-secret -n matrix >/dev/null 2>&1; then
  echo "Success: secret matrix-secret exists in matrix (no hash suffix)"
  exit 0
fi
echo "Error: secret matrix-secret not found in matrix (ensure disableNameSuffixHash is used)"
exit 1
