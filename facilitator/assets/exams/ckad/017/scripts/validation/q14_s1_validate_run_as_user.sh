#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
uid=$(kubectl get pod secure-pod -n abyss -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)
if [ "$uid" = "1000" ]; then
  echo "Success: runAsUser is 1000"; exit 0
fi
echo "Error: runAsUser is '$uid', expected 1000"; exit 1
