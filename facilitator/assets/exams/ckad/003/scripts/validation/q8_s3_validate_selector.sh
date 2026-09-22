#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl get service backend-headless -n corona -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$s" = "backend" ]; then
  echo "Success: selector app=backend"
  exit 0
else
  echo "Error: selector app is '$s', expected backend"
  exit 1
fi
