#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
lc=$(kubectl get pod lifecycle-pod -n phoenix -o jsonpath='{.spec.containers[0].lifecycle.postStart}' 2>/dev/null)
if [ -n "$lc" ]; then
  echo "Success: postStart hook present"
  exit 0
else
  echo "Error: postStart lifecycle hook not found"
  exit 1
fi
