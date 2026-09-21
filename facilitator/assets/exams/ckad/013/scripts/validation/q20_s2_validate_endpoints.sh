#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
e=$(kubectl get endpoints dns-svc -n sunbeam -o jsonpath='{.subsets[0].addresses}' 2>/dev/null)
if [ -n "$e" ]; then
  echo "Success: service has endpoints"
  exit 0
else
  echo "Error: service has no endpoints"
  exit 1
fi
