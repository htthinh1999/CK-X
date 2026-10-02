#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# count app containers + native sidecars (init containers with restartPolicy Always)
c=$(kubectl get pod data-transform -n phoenix -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length')
if [ "$c" = "2" ]; then
  echo "Success: 2 containers"
  exit 0
else
  echo "Error: container count is '$c', expected 2"
  exit 1
fi
