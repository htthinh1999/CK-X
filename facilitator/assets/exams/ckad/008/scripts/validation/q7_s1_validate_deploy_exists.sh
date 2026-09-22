#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get deployment rollback-deploy -n cave >/dev/null 2>&1; then
  echo "Success: deployment rollback-deploy exists"; exit 0
else
  echo "Error: deployment rollback-deploy not found"; exit 1
fi
