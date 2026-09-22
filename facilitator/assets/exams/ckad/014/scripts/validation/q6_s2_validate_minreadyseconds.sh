#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mr=$(kubectl get deployment slow-start-app -n shadow -o jsonpath='{.spec.minReadySeconds}' 2>/dev/null)
if [ "$mr" == "20" ]; then
  echo "Success: minReadySeconds is 20"
  exit 0
else
  echo "Error: minReadySeconds is '$mr', expected 20"
  exit 1
fi
