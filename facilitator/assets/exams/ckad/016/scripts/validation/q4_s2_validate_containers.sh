#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# containers + native sidecars (init containers with restartPolicy: Always)
names=$(kubectl get pod thunder-logger -n thunder -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | map(.name) | join(" ")' 2>/dev/null)
if [[ "$names" == *"app-container"* ]] && [[ "$names" == *"error-tailer"* ]]; then
  echo "Success: both containers present"; exit 0
fi
echo "Error: containers app-container and error-tailer not both present (got: $names)"; exit 1
