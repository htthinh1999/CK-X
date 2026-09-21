#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

d=$(kubectl get job deadline-job -n hollow -o jsonpath='{.spec.activeDeadlineSeconds}' 2>/dev/null)
if [ "$d" = "30" ]; then
  echo "Success: activeDeadlineSeconds 30 correct"; exit 0
else
  echo "Error: activeDeadlineSeconds is '$d', expected 30"; exit 1
fi
