#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get pod logger -n glade >/dev/null 2>&1; then
  echo "Success: pod logger exists in glade"; exit 0
else
  echo "Error: pod logger not found in glade"; exit 1
fi
