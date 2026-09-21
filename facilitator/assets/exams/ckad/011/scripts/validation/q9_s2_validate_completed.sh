#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
phase=$(kubectl get pod echo-pod -n current -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$phase" = "Succeeded" ] || [ "$phase" = "Completed" ]; then
  echo "Success: Pod echo-pod completed (phase $phase)"
  exit 0
else
  echo "Error: Pod echo-pod phase is '$phase', expected Succeeded/Completed"
  exit 1
fi
