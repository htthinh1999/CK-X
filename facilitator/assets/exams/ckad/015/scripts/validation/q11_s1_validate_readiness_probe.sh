#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get pod monsoon-checker -n monsoon >/dev/null 2>&1 || { echo "Error: Pod monsoon-checker not found in monsoon"; exit 1; }
prob=$(kubectl get pod monsoon-checker -n monsoon -o jsonpath='{.spec.containers[0].readinessProbe.exec.command[0]}' 2>/dev/null)
if [ "$prob" == "cat" ]; then
  echo "Success: readiness exec probe uses cat"
  exit 0
else
  echo "Error: readinessProbe.exec.command[0]='$prob' (expected cat)"
  exit 1
fi
