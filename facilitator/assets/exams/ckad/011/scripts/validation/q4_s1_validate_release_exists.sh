#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
info=$(helm list -n wave -o json 2>/dev/null | grep -o '"name":"rollback-app"' || true)
if [ -n "$info" ]; then
  echo "Success: helm release rollback-app exists in wave"
  exit 0
else
  echo "Error: helm release rollback-app not found in wave"
  exit 1
fi
