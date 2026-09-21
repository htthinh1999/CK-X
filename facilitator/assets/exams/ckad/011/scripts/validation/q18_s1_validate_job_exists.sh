#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get job pi-job -n coral >/dev/null 2>&1; then
  echo "Success: Job pi-job exists in coral"
  exit 0
else
  echo "Error: Job pi-job not found in coral"
  exit 1
fi
