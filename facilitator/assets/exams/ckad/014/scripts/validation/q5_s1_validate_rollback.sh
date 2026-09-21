#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
rev=$(helm history api-release -n nebula -o json 2>/dev/null | jq -r '.[-1].description' 2>/dev/null)
if [[ "$rev" == *"Rollback to 1"* ]]; then
  echo "Success: release api-release rolled back to 1"
  exit 0
else
  echo "Error: release not rolled back to 1 (last description: '$rev')"
  exit 1
fi
