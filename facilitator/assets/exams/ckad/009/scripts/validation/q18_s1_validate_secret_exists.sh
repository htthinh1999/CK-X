#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get secret api-secret -n moss >/dev/null 2>&1; then
  echo "Success: secret api-secret exists in moss"; exit 0
else
  echo "Error: secret api-secret not found in moss"; exit 1
fi
