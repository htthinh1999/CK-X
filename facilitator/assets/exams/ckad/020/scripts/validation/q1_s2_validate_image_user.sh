#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! docker image inspect localhost:5000/genesis-app:v1 >/dev/null 2>&1; then
  echo "Error: image localhost:5000/genesis-app:v1 not found locally"
  exit 1
fi
user=$(docker image inspect localhost:5000/genesis-app:v1 2>/dev/null | jq -r '.[0].Config.User')
if [ "$user" = "1000" ]; then
  echo "Success: image runs as USER 1000"
  exit 0
fi
echo "Error: image USER is '$user', expected 1000"
exit 1
