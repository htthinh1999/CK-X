#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
requests=$(kubectl get pod logging-pod -n aegis -o jsonpath='{.spec.containers[?(@.name=="app-container")].resources.requests.cpu}' 2>/dev/null)
if [[ -n "$requests" ]]; then
  echo "Success: app-container cpu request set ($requests)"
  exit 0
fi
echo "Error: app-container resource requests missing"
exit 1
