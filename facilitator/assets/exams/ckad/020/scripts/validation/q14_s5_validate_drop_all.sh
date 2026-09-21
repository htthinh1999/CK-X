#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
drop=$(kubectl get pod secure-pod -n ancient -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop}' 2>/dev/null)
if [[ "$drop" == *"ALL"* ]]; then
  echo "Success: capabilities drop includes ALL"
  exit 0
fi
echo "Error: capabilities.drop is '$drop', expected to include ALL"
exit 1
