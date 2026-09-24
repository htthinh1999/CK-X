#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get deployment nginx-deploy -n valley >/dev/null 2>&1; then
  echo "Success: deployment nginx-deploy exists"; exit 0
else
  echo "Error: deployment nginx-deploy not found"; exit 1
fi
