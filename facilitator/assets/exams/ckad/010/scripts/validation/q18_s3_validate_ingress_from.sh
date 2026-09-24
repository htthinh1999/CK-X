#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get networkpolicy db-policy -n shrine -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.access}' 2>/dev/null)
if [ "$val" = "true" ]; then
  echo "Success: ingress from access=true correct"
  exit 0
else
  echo "Error: ingress rule incorrect (got '$val')"
  exit 1
fi
