#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if docker images localhost:5000/phoenix-app:2.0.0 --format "{{.Repository}}" 2>/dev/null | grep -q "phoenix-app"; then
  echo "Success: image built"
  exit 0
else
  echo "Error: image localhost:5000/phoenix-app:2.0.0 not found locally"
  exit 1
fi
