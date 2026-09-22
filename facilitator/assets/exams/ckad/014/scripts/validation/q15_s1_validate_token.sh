#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get secret legacy-token -n shadow -o jsonpath='{.data.token}' 2>/dev/null | base64 -d 2>/dev/null)
if [ "$val" == "super-secret-v2" ]; then
  echo "Success: token updated to super-secret-v2"
  exit 0
else
  echo "Error: token value is '$val', expected super-secret-v2"
  exit 1
fi
