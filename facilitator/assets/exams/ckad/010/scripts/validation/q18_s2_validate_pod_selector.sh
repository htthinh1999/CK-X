#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get networkpolicy db-policy -n shrine -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
if [ "$val" = "db" ]; then
  echo "Success: podSelector app=db correct"
  exit 0
else
  echo "Error: podSelector incorrect (got '$val')"
  exit 1
fi
