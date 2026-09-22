#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
containers=$(kubectl get pod logging-pod -n aegis -o jsonpath='{.spec.containers[*].name}' 2>/dev/null)
if [[ "$containers" == *"app-container"* ]] && [[ "$containers" == *"log-tailer"* ]]; then
  echo "Success: both containers present"
  exit 0
fi
echo "Error: containers missing (found: $containers)"
exit 1
