#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if docker images solar-app:1.0 --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | grep -q "solar-app:1.0"; then
  echo "Success: image solar-app:1.0 exists"
  exit 0
else
  echo "Error: image solar-app:1.0 not found"
  exit 1
fi
