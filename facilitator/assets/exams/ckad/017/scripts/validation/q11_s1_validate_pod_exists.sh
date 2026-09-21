#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod grpc-checker -n ocean >/dev/null 2>&1; then
  echo "Success: pod grpc-checker exists in ocean"; exit 0
fi
echo "Error: pod grpc-checker not found in ocean"; exit 1
