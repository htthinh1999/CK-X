#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod envpod -n summit >/dev/null 2>&1; then
  echo "Success: pod envpod exists"; exit 0
else
  echo "Error: pod envpod not found"; exit 1
fi
