#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod qos-guaranteed -n spark >/dev/null 2>&1; then
  echo "Success: pod exists"
  exit 0
else
  echo "Error: pod qos-guaranteed not found in spark"
  exit 1
fi
