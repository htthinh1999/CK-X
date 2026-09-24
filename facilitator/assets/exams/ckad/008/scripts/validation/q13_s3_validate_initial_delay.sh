#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get pod liveness-pod -n stone -o jsonpath='{.spec.containers[0].livenessProbe.initialDelaySeconds}' 2>/dev/null)
if [ "$v" = "5" ]; then
  echo "Success: initialDelaySeconds is 5"; exit 0
else
  echo "Error: initialDelaySeconds is '$v', expected 5"; exit 1
fi
