#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
hr=$(helm list -n current --short 2>/dev/null | grep ocean-api || echo "")
if [ -z "$hr" ]; then
  echo "Success: helm release ocean-api uninstalled"; exit 0
fi
echo "Error: helm release ocean-api still exists"; exit 1
