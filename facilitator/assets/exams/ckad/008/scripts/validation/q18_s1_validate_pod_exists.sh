#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get pod liveness-pod -n stone >/dev/null 2>&1; then
  echo "Success: pod liveness-pod exists"; exit 0
else
  echo "Error: pod liveness-pod not found"; exit 1
fi
