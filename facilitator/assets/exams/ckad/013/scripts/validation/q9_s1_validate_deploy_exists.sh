#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment slow-app -n eclipse >/dev/null 2>&1; then
  echo "Success: deployment slow-app exists"
  exit 0
else
  echo "Error: deployment slow-app not found"
  exit 1
fi
