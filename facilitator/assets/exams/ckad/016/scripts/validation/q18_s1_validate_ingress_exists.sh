#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress default-ing -n surge >/dev/null 2>&1; then
  echo "Success: ingress default-ing exists"; exit 0
fi
echo "Error: ingress default-ing not found in surge"; exit 1
