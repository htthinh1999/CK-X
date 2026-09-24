#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
vols=$(kubectl get pod combined-app -n crescent -o jsonpath='{.spec.volumes[*].projected.sources}' 2>/dev/null)
if [[ "$vols" == *"db-creds"* ]]; then
  echo "Success: secret db-creds projected"
  exit 0
else
  echo "Error: secret db-creds not projected in a projected volume"
  exit 1
fi
