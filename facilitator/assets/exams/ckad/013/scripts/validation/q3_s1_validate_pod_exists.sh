#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod web-with-sidecar -n corona >/dev/null 2>&1; then
  echo "Success: pod web-with-sidecar exists"
  exit 0
else
  echo "Error: pod web-with-sidecar not found"
  exit 1
fi
