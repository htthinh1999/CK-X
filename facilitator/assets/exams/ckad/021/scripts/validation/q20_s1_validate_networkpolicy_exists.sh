#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy strict-net -n helm >/dev/null 2>&1; then
  echo "Success: networkpolicy strict-net exists in helm"
  exit 0
fi
echo "Error: networkpolicy strict-net missing in helm"
exit 1
