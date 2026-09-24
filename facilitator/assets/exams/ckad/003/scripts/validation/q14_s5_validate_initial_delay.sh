#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
d=$(kubectl get pod tcp-health -n ember -o jsonpath='{.spec.containers[0].livenessProbe.initialDelaySeconds}' 2>/dev/null)
if [ "$d" = "10" ]; then
  echo "Success: initialDelaySeconds 10"
  exit 0
else
  echo "Error: initialDelaySeconds is '$d', expected 10"
  exit 1
fi
