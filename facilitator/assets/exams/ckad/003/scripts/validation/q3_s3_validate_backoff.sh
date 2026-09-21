#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
b=$(kubectl get job data-processor -n spark -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)
if [ "$b" = "2" ]; then
  echo "Success: backoffLimit is 2"
  exit 0
else
  echo "Error: backoffLimit is '$b', expected 2"
  exit 1
fi
