#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get cm options -n summit -o jsonpath='{.data.var5}' 2>/dev/null)
if [ "$v" = "val5" ]; then
  echo "Success: var5 is val5"; exit 0
else
  echo "Error: var5 is '$v', expected val5"; exit 1
fi
