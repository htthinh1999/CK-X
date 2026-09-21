#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

v=$(kubectl get pod liveness-pod -n stone -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}' 2>/dev/null)
if [ "$v" = "5" ]; then
  echo "Success: periodSeconds is 5"; exit 0
else
  echo "Error: periodSeconds is '$v', expected 5"; exit 1
fi
