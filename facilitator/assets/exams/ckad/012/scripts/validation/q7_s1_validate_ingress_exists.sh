#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get ingress frontend-ingress -n bastion >/dev/null 2>&1; then
  echo "Success: Ingress frontend-ingress exists in bastion"
  exit 0
else
  echo "Error: Ingress frontend-ingress exists in bastion - not found"
  exit 1
fi
