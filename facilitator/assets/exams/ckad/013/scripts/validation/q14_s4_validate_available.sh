#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
a=$(kubectl get deploy hardened-app -n dawn -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
if [ -n "$a" ] && [ "$a" -ge 1 ]; then
  echo "Success: deployment has available replicas"
  exit 0
else
  echo "Error: no available replicas"
  exit 1
fi
