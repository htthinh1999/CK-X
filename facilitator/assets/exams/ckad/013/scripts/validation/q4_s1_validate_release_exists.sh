#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
info=$(helm list -n radiance -f web-release -o json 2>/dev/null | grep -o '"name":"web-release"' || true)
if [ -n "$info" ]; then
  echo "Success: release web-release exists"
  exit 0
else
  echo "Error: release web-release not found"
  exit 1
fi
