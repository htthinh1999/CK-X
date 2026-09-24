#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get deployment canary-app -n bulwark -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ "$val" = "webapp" ]; then
  echo "Success: Template label app ($val)"
  exit 0
else
  echo "Error: Template label app - got '$val', expected 'webapp'"
  exit 1
fi
