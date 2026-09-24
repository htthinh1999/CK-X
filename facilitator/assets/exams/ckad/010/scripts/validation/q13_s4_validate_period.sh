#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod live-pod -n shrine -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}' 2>/dev/null)
if [ "$val" = "10" ]; then
  echo "Success: periodSeconds is 10"
  exit 0
else
  echo "Error: periodSeconds incorrect (got '$val')"
  exit 1
fi
