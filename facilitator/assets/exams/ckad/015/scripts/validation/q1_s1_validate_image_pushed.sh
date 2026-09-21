#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if curl -s http://localhost:5000/v2/fujin-api/tags/list 2>/dev/null | grep -q 'v2'; then
  echo "Success: image fujin-api:v2 present in local registry"
  exit 0
else
  echo "Error: image fujin-api:v2 not found in registry localhost:5000"
  exit 1
fi
