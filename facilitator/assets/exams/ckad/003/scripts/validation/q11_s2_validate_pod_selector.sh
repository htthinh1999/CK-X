#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl get networkpolicy allow-from-flame -n corona -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
if [ "$s" = "backend" ]; then
  echo "Success: podSelector app=backend"
  exit 0
else
  echo "Error: podSelector app is '$s', expected backend"
  exit 1
fi
