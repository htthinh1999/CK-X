#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod tri-blade -n summit >/dev/null 2>&1; then
  echo "Success: pod tri-blade exists in summit"
  exit 0
fi
echo "Error: pod tri-blade not found in summit"
exit 1
