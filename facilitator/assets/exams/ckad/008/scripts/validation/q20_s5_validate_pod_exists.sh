#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod pv-pod -n alpine >/dev/null 2>&1; then
  echo "Success: pod pv-pod exists"; exit 0
else
  echo "Error: pod pv-pod not found"; exit 1
fi
