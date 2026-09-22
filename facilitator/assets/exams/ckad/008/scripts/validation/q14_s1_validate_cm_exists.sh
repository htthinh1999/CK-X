#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get configmap cmvolume -n cliff >/dev/null 2>&1; then
  echo "Success: configmap cmvolume exists"; exit 0
else
  echo "Error: configmap cmvolume not found"; exit 1
fi
