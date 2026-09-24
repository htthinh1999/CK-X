#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if docker image inspect localhost:5000/genesis-app:v1 >/dev/null 2>&1; then
  echo "Success: image localhost:5000/genesis-app:v1 exists locally"
  exit 0
fi
echo "Error: image localhost:5000/genesis-app:v1 not found locally"
exit 1
