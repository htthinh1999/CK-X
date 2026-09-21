#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod optimized-build -n ward >/dev/null 2>&1; then
  echo "Success: pod optimized-build exists in ward"
  exit 0
fi
echo "Error: pod optimized-build missing in ward"
exit 1
