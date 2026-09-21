#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ru=$(kubectl get pod secure-pod -n eclipse -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)
if [ "$ru" == "1000" ]; then
  echo "Success: runAsUser is 1000"
  exit 0
else
  echo "Error: runAsUser is '$ru', expected 1000"
  exit 1
fi
