#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if docker manifest inspect --insecure localhost:5000/phoenix-app:2.0.0 >/dev/null 2>&1; then
  echo "Success: image pushed to registry"
  exit 0
else
  echo "Error: image not pushed to localhost:5000"
  exit 1
fi
