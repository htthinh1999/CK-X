#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ann=$(kubectl get deploy frontend-app -n solar -o jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}' 2>/dev/null)
if [ "$ann" = "initial deployment" ]; then
  echo "Success: change-cause annotation correct"
  exit 0
else
  echo "Error: annotation is '$ann'"
  exit 1
fi
