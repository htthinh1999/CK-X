#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod tolerate-pod -n moss >/dev/null 2>&1; then
  echo "Success: pod tolerate-pod exists in moss"; exit 0
else
  echo "Error: pod tolerate-pod not found in moss"; exit 1
fi
