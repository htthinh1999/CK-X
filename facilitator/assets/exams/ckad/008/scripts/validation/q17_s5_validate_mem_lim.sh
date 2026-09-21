#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

v=$(kubectl get pod resource-pod -n cave -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)
if [ "$v" = "512Mi" ]; then
  echo "Success: memory limit is 512Mi"; exit 0
else
  echo "Error: memory limit is '$v', expected 512Mi"; exit 1
fi
