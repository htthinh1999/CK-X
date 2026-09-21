#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
completions=$(kubectl get job index-processor -n primal -o jsonpath='{.spec.completions}' 2>/dev/null)
if [ "$completions" = "5" ]; then
  echo "Success: completions is 5"
  exit 0
fi
echo "Error: completions is '$completions', expected 5"
exit 1
