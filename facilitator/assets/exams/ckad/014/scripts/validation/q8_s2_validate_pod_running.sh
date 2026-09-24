#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
status=$(kubectl get pod metrics-gatherer -n starlight -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$status" == "Running" ]; then
  echo "Success: pod metrics-gatherer is Running"
  exit 0
else
  echo "Error: pod status is '$status', expected Running"
  exit 1
fi
