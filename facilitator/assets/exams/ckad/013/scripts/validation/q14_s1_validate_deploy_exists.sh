#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment hardened-app -n dawn >/dev/null 2>&1; then
  echo "Success: deployment hardened-app exists"
  exit 0
else
  echo "Error: deployment hardened-app not found"
  exit 1
fi
