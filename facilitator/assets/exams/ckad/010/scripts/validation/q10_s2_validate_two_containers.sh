#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cnt=$(kubectl get pod shared-pod -n bounty -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$cnt" -ge 2 ] 2>/dev/null; then
  echo "Success: two containers present ($cnt containers)"
  exit 0
else
  echo "Error: less than 2 containers ($cnt containers)"
  exit 1
fi
