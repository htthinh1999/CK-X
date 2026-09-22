#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod nginx -n mynamespace >/dev/null 2>&1; then
  echo "Success: pod nginx exists"; exit 0
else
  echo "Error: pod nginx not found"; exit 1
fi
