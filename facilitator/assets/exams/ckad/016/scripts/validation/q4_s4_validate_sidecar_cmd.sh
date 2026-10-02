#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# error-tailer may be a regular container or a native sidecar (init container with restartPolicy: Always)
cmd=$(kubectl get pod thunder-logger -n thunder -o json 2>/dev/null | jq -c '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | select(.name == "error-tailer") | [.command, .args]' 2>/dev/null)
# filter with grep (e.g. grep ERROR) or awk (e.g. awk '/ERROR/ {print; fflush()}')
if [[ "$cmd" == *"ERROR"* ]] && [[ "$cmd" == *"grep"* || "$cmd" == *"awk"* ]]; then
  echo "Success: sidecar command filters ERROR lines"; exit 0
fi
echo "Error: error-tailer command does not filter ERROR lines with grep or awk (got: $cmd)"; exit 1
