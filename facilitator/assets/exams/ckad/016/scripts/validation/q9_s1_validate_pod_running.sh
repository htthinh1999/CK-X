#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get pod data-processor -n flash >/dev/null 2>&1; then
  echo "Error: pod data-processor not found in flash"; exit 1
fi
phase=$(kubectl get pod data-processor -n flash -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$phase" = "Running" ]; then echo "Success: pod is Running"; exit 0; fi
echo "Error: pod phase is '$phase', expected Running"; exit 1
