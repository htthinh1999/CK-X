#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod init-pod -n crest >/dev/null 2>&1; then
  echo "Success: pod init-pod exists"; exit 0
else
  echo "Error: pod init-pod not found"; exit 1
fi
