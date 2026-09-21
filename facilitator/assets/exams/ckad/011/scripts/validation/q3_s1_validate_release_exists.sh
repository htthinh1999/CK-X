#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
info=$(helm list -n tide -o json 2>/dev/null | grep -o '"name":"my-release"' || true)
if [ -n "$info" ]; then
  echo "Success: helm release my-release exists in tide"
  exit 0
else
  echo "Error: helm release my-release not found in tide"
  exit 1
fi
