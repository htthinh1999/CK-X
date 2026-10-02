#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# app containers + native sidecars (init containers with restartPolicy Always)
containers=$(kubectl get pod tri-blade -n summit -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | map(.name) | join(" ")')
if [[ "$containers" == *"main"* && "$containers" == *"sidecar"* && "$containers" == *"adapter"* ]]; then
  echo "Success: containers main, sidecar and adapter present"
  exit 0
fi
echo "Error: containers mismatch, got '$containers'"
exit 1
