#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get deployment critical-processor -n nightfall >/dev/null 2>&1; then
  echo "Error: deployment critical-processor not found in nightfall"
  exit 1
fi
paused=$(kubectl get deployment critical-processor -n nightfall -o jsonpath='{.spec.paused}' 2>/dev/null)
if [ "$paused" == "true" ]; then
  echo "Success: deployment critical-processor is paused"
  exit 0
else
  echo "Error: deployment is not paused (paused='$paused')"
  exit 1
fi
