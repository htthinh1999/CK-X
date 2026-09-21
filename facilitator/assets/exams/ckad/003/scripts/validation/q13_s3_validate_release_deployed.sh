#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
st=$(helm status phoenix-api -n flare -o json 2>/dev/null | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
if [ "$st" = "deployed" ]; then
  echo "Success: release deployed"
  exit 0
else
  echo "Error: release status is '$st', expected deployed"
  exit 1
fi
