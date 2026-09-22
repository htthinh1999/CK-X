#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get svc webapp-svc -n flare -o jsonpath='{.spec.selector.version}' 2>/dev/null)
if [ "$v" = "green" ]; then
  echo "Success: service selector version=green"
  exit 0
else
  echo "Error: service selector version is '$v'"
  exit 1
fi
