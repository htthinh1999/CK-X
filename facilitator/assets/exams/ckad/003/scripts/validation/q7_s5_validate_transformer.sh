#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# transformer may be a regular container or a native sidecar (init container with restartPolicy Always)
n=$(kubectl get pod data-transform -n phoenix -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | .[] | select(.name == "transformer") | .name')
if [ "$n" = "transformer" ]; then
  echo "Success: transformer container exists"
  exit 0
else
  echo "Error: transformer container not found"
  exit 1
fi
