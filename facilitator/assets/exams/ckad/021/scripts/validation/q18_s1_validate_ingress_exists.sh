#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress regex-ingress -n bulwark >/dev/null 2>&1; then
  echo "Success: ingress regex-ingress exists in bulwark"
  exit 0
fi
echo "Error: ingress regex-ingress missing in bulwark"
exit 1
