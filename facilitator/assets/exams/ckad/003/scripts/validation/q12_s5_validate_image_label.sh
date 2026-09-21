#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
l=$(docker inspect localhost:5000/phoenix-app:2.0.0 --format '{{index .Config.Labels "version"}}' 2>/dev/null)
if [ "$l" = "2.0.0" ]; then
  echo "Success: image label version=2.0.0"
  exit 0
else
  echo "Error: image version label is '$l', expected 2.0.0"
  exit 1
fi
