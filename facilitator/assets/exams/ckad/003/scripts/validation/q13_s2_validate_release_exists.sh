#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if helm status phoenix-api -n flare >/dev/null 2>&1; then
  echo "Success: release phoenix-api exists"
  exit 0
else
  echo "Error: helm release phoenix-api not found in flare"
  exit 1
fi
