#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get secret file-secret -n fern >/dev/null 2>&1; then
  echo "Success: secret file-secret exists in fern"; exit 0
else
  echo "Error: secret file-secret not found in fern"; exit 1
fi
