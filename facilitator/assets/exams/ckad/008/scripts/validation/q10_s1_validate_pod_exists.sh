#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod multi-container -n alpine >/dev/null 2>&1; then
  echo "Success: pod multi-container exists"; exit 0
else
  echo "Error: pod multi-container not found"; exit 1
fi
