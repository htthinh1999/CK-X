#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get configmap options -n summit >/dev/null 2>&1; then
  echo "Success: configmap options exists"; exit 0
else
  echo "Error: configmap options not found"; exit 1
fi
