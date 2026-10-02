#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# containers + native sidecars (init containers with restartPolicy: Always)
count=$(kubectl get pod sidecar-pod -n abyss -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length' 2>/dev/null)
count=${count:-0}
if [ "$count" -ge 2 ] 2>/dev/null; then
  echo "Success: Pod has $count containers (incl. native sidecars)"
  exit 0
else
  echo "Error: Pod has $count container(s) (incl. native sidecars), expected 2"
  exit 1
fi
