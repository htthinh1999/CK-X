#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get networkpolicy api-allow -n sunbeam -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
if [ "$p" = "api" ]; then
  echo "Success: podSelector targets app=api"
  exit 0
else
  echo "Error: podSelector app='$p'"
  exit 1
fi
