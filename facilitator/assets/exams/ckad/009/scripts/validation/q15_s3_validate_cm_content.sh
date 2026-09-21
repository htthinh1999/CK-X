#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

content=$(kubectl get configmap file-config -n glade -o jsonpath='{.data}' 2>/dev/null)
if [[ "$content" == *"foo3"* ]] || [[ "$content" == *"lili"* ]]; then
  echo "Success: configmap content correct"; exit 0
else
  echo "Error: configmap content missing foo3/lili"; exit 1
fi
