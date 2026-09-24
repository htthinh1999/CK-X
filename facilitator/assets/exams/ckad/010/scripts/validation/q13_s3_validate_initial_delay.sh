#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod live-pod -n shrine -o jsonpath='{.spec.containers[0].livenessProbe.initialDelaySeconds}' 2>/dev/null)
if [ "$val" = "5" ]; then
  echo "Success: initialDelaySeconds is 5"
  exit 0
else
  echo "Error: initialDelaySeconds incorrect (got '$val')"
  exit 1
fi
