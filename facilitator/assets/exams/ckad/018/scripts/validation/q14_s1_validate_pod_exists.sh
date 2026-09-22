#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod selinux-pod -n cadence >/dev/null 2>&1; then
  echo "Success: pod selinux-pod exists"; exit 0
fi
echo "Error: pod selinux-pod not found in cadence"; exit 1
