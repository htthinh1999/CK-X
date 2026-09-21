#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get service nginx -n grove >/dev/null 2>&1; then
  echo "Success: service nginx exists in grove"; exit 0
else
  echo "Error: service nginx not found in grove"; exit 1
fi
