#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

sa=$(kubectl get pod sa-pod -n root -o jsonpath='{.spec.serviceAccountName}' 2>/dev/null)
if [ "$sa" = "app-sa" ]; then
  echo "Success: serviceAccountName app-sa configured"; exit 0
else
  echo "Error: serviceAccountName is '$sa', expected app-sa"; exit 1
fi
