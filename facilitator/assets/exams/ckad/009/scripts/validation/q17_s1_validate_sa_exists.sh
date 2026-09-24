#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get serviceaccount app-sa -n root >/dev/null 2>&1; then
  echo "Success: serviceaccount app-sa exists in root"; exit 0
else
  echo "Error: serviceaccount app-sa not found in root"; exit 1
fi
