#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

p=$(kubectl get job parallel-job -n canopy -o jsonpath='{.spec.parallelism}' 2>/dev/null)
if [ "$p" = "5" ]; then
  echo "Success: parallelism 5 correct"; exit 0
else
  echo "Error: parallelism is '$p', expected 5"; exit 1
fi
