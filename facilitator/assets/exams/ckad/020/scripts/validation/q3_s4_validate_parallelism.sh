#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
para=$(kubectl get job index-processor -n primal -o jsonpath='{.spec.parallelism}' 2>/dev/null)
if [ "$para" = "2" ]; then
  echo "Success: parallelism is 2"
  exit 0
fi
echo "Error: parallelism is '$para', expected 2"
exit 1
