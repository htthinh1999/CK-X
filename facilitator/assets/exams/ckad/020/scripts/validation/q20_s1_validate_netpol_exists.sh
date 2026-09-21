#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy isolate-namespace -n nexus >/dev/null 2>&1; then
  echo "Success: networkpolicy isolate-namespace exists in nexus"
  exit 0
fi
echo "Error: networkpolicy isolate-namespace not found in nexus"
exit 1
