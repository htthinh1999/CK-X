#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

v=$(kubectl get job echo-job -n stone -o jsonpath='{.spec.completions}' 2>/dev/null)
if [ "$v" = "5" ]; then
  echo "Success: completions is 5"; exit 0
else
  echo "Error: completions is '$v', expected 5"; exit 1
fi
