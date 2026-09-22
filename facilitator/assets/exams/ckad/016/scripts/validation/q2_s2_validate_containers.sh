#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
names=$(kubectl get pod thunder-logger -n thunder -o jsonpath='{.spec.containers[*].name}' 2>/dev/null)
if [[ "$names" == *"app-container"* ]] && [[ "$names" == *"error-tailer"* ]]; then
  echo "Success: both containers present"; exit 0
fi
echo "Error: containers app-container and error-tailer not both present (got: $names)"; exit 1
