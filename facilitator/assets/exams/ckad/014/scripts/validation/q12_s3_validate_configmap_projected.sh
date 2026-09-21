#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
vols=$(kubectl get pod combined-app -n crescent -o jsonpath='{.spec.volumes[*].projected.sources}' 2>/dev/null)
if [[ "$vols" == *"app-config"* ]]; then
  echo "Success: configmap app-config projected"
  exit 0
else
  echo "Error: configmap app-config not projected in a projected volume"
  exit 1
fi
