#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get pod stuck-pod -n cosmos >/dev/null 2>&1; then
  echo "Error: pod stuck-pod not found in cosmos"
  exit 1
fi
phase=$(kubectl get pod stuck-pod -n cosmos -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$phase" = "Running" ]; then
  echo "Success: pod stuck-pod is Running"
  exit 0
fi
echo "Error: pod stuck-pod phase is '$phase', expected Running"
exit 1
