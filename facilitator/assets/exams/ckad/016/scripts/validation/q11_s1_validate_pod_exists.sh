#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod complex-app -n plasma >/dev/null 2>&1; then
  echo "Success: pod complex-app exists"; exit 0
fi
echo "Error: pod complex-app not found in plasma"; exit 1
