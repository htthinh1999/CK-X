#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod env-info -n thunder >/dev/null 2>&1; then
  echo "Success: pod env-info exists"; exit 0
fi
echo "Error: pod env-info not found in thunder"; exit 1
