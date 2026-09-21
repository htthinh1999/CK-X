#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
anno=$(kubectl get deployment eden-api -n eden -o jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}' 2>/dev/null)
if [ -n "$anno" ]; then
  echo "Success: change-cause annotation is set"
  exit 0
fi
echo "Error: change-cause annotation not found on eden-api"
exit 1
