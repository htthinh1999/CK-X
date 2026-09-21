#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy strict-ingress -n charge >/dev/null 2>&1; then
  echo "Success: networkpolicy strict-ingress exists"; exit 0
fi
echo "Error: networkpolicy strict-ingress not found in charge"; exit 1
