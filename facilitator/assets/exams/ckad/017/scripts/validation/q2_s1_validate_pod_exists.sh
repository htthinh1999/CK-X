#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod log-generator -n tide >/dev/null 2>&1; then
  echo "Success: pod log-generator exists in tide"; exit 0
fi
echo "Error: pod log-generator not found in tide"; exit 1
