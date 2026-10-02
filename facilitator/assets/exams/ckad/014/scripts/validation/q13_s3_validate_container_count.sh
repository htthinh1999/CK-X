#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if ! kubectl get pod logger -n lunar >/dev/null 2>&1; then
  echo "Error: pod logger not found in lunar"
  exit 1
fi
# containers + native sidecars (init containers with restartPolicy: Always)
count=$(kubectl get pod logger -n lunar -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | .name' 2>/dev/null | grep -c .)
if [ "$count" == "2" ]; then
  echo "Success: pod logger has two containers (incl. native sidecars)"
  exit 0
else
  echo "Error: pod logger has '$count' containers (incl. native sidecars), expected 2"
  exit 1
fi
