#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod inject-pod -n zenith >/dev/null 2>&1; then
  echo "Success: pod inject-pod exists in zenith"
  exit 0
fi
echo "Error: pod inject-pod not found in zenith"
exit 1
