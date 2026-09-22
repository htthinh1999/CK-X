#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get service web -n mist >/dev/null 2>&1; then
  echo "Success: service web exists"; exit 0
else
  echo "Error: service web not found"; exit 1
fi
