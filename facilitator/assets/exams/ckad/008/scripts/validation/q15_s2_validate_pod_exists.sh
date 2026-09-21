#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get pod secret-pod -n ridge >/dev/null 2>&1; then
  echo "Success: pod secret-pod exists"; exit 0
else
  echo "Error: pod secret-pod not found"; exit 1
fi
