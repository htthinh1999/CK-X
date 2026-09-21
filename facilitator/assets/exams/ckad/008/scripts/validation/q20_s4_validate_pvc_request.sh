#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

v=$(kubectl get pvc mypvc -n alpine -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
if [ "$v" = "4Gi" ]; then
  echo "Success: PVC request is 4Gi"; exit 0
else
  echo "Error: PVC request is '$v', expected 4Gi"; exit 1
fi
