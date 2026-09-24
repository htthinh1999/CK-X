#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get pod token-pod -n magma -o json 2>/dev/null | grep -c "projected")
if [ "$p" -gt 0 ] 2>/dev/null; then
  echo "Success: projected volume present"
  exit 0
else
  echo "Error: no projected volume found"
  exit 1
fi
