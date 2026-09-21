#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ph=$(kubectl get pod qos-guaranteed -n spark -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$ph" = "Running" ]; then
  echo "Success: pod Running"
  exit 0
else
  echo "Error: pod phase is '$ph', expected Running"
  exit 1
fi
