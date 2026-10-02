#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# error-tailer may be a regular container or a native sidecar (init container with restartPolicy: Always)
cmd=$(kubectl get pod thunder-logger -n thunder -o json 2>/dev/null | jq -c '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | select(.name == "error-tailer") | .command' 2>/dev/null)
if [[ "$cmd" == *"grep"* ]] && [[ "$cmd" == *"ERROR"* ]]; then
  echo "Success: sidecar tail/grep ERROR command present"; exit 0
fi
echo "Error: error-tailer command missing grep ERROR (got: $cmd)"; exit 1
