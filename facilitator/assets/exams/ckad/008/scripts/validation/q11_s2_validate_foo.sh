#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get cm app-config -n peak -o jsonpath='{.data.foo}' 2>/dev/null)
if [ "$v" = "lala" ]; then
  echo "Success: foo is lala"; exit 0
else
  echo "Error: foo is '$v', expected lala"; exit 1
fi
