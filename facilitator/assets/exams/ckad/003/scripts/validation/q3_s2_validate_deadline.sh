#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
d=$(kubectl get job data-processor -n spark -o jsonpath='{.spec.activeDeadlineSeconds}' 2>/dev/null)
if [ "$d" = "60" ]; then
  echo "Success: activeDeadlineSeconds is 60"
  exit 0
else
  echo "Error: activeDeadlineSeconds is '$d', expected 60"
  exit 1
fi
