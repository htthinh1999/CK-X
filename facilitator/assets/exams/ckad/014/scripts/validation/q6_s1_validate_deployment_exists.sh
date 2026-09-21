#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment slow-start-app -n shadow >/dev/null 2>&1; then
  echo "Success: deployment slow-start-app exists in shadow"
  exit 0
else
  echo "Error: deployment slow-start-app not found in shadow"
  exit 1
fi
