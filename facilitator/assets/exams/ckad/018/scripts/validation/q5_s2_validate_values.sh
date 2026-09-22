#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rep=$(helm get values wisdom-app -n chorus 2>/dev/null | grep replicaCount)
if [[ -n "$rep" ]]; then
  echo "Success: custom replicaCount value set ($rep)"; exit 0
fi
echo "Error: replicaCount value not set on release"; exit 1
