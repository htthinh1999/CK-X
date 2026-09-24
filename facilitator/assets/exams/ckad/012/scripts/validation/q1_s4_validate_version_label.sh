#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get deployment canary-app -n bulwark -o jsonpath='{.spec.template.metadata.labels.version}' 2>/dev/null)
if [ "$val" = "v2" ]; then
  echo "Success: Template label version ($val)"
  exit 0
else
  echo "Error: Template label version - got '$val', expected 'v2'"
  exit 1
fi
