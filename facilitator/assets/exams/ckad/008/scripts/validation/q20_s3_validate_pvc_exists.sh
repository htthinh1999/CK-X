#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get persistentvolumeclaim mypvc -n alpine >/dev/null 2>&1; then
  echo "Success: persistentvolumeclaim mypvc exists"; exit 0
else
  echo "Error: persistentvolumeclaim mypvc not found"; exit 1
fi
