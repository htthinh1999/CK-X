#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cnt=$(kubectl get pods -n harvest -l env=dev -o name 2>/dev/null | wc -l)
if [ "$cnt" -ge 1 ] 2>/dev/null; then
  echo "Success: pod with env=dev exists ($cnt pods)"
  exit 0
else
  echo "Error: no pod with env=dev ($cnt pods)"
  exit 1
fi
