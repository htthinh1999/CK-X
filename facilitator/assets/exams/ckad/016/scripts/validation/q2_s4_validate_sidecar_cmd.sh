#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cmd=$(kubectl get pod thunder-logger -n thunder -o jsonpath='{.spec.containers[?(@.name=="error-tailer")].command}' 2>/dev/null)
if [[ "$cmd" == *"grep"* ]] && [[ "$cmd" == *"ERROR"* ]]; then
  echo "Success: sidecar tail/grep ERROR command present"; exit 0
fi
echo "Error: error-tailer command missing grep ERROR (got: $cmd)"; exit 1
