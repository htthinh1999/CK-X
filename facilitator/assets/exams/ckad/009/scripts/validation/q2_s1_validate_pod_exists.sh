#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod nginx -n grove >/dev/null 2>&1; then
  echo "Success: pod nginx exists in grove"; exit 0
else
  echo "Error: pod nginx not found in grove"; exit 1
fi
