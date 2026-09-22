#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get service web -n harvest >/dev/null 2>&1; then
  echo "Success: Service web exists in harvest"
  exit 0
else
  echo "Error: Service web not found in harvest"
  exit 1
fi
