#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f=$(kubectl get deploy slow-app -n eclipse -o jsonpath='{.spec.template.spec.containers[0].startupProbe.failureThreshold}' 2>/dev/null)
if [ "$f" = "30" ]; then
  echo "Success: failureThreshold 30"
  exit 0
else
  echo "Error: failureThreshold is '$f'"
  exit 1
fi
