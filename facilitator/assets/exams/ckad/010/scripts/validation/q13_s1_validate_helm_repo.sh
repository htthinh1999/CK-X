#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if helm repo list 2>/dev/null | grep -iq bitnami; then
  echo "Success: bitnami repo added"
  exit 0
else
  echo "Error: bitnami repo not found"
  exit 1
fi
