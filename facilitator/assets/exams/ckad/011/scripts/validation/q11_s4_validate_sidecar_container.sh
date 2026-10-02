#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# sidecar may be a regular container or a native sidecar (init container with restartPolicy: Always)
name=$(kubectl get pod sidecar-pod -n abyss -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | select(.name == "sidecar") | .name' 2>/dev/null)
if [ "$name" = "sidecar" ]; then
  echo "Success: container sidecar exists"
  exit 0
else
  echo "Error: container sidecar not found"
  exit 1
fi
