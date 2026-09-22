#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get pod tcp-health -n ember -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}' 2>/dev/null)
if [ "$p" = "5" ]; then
  echo "Success: periodSeconds 5"
  exit 0
else
  echo "Error: periodSeconds is '$p', expected 5"
  exit 1
fi
