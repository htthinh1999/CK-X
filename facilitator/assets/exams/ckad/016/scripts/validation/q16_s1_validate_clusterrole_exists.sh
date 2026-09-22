#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get clusterrole secret-reader >/dev/null 2>&1; then
  echo "Success: clusterrole secret-reader exists"; exit 0
fi
echo "Error: clusterrole secret-reader not found"; exit 1
