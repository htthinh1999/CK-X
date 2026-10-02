#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# app containers + native sidecars (init containers with restartPolicy Always)
containers=$(kubectl get pod logging-pod -n aegis -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | map(.name) | join(" ")')
if [[ "$containers" == *"app-container"* ]] && [[ "$containers" == *"log-tailer"* ]]; then
  echo "Success: both containers present"
  exit 0
fi
echo "Error: containers missing (found: $containers)"
exit 1
