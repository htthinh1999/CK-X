#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
user=$(kubectl get pod secure-pod -n summit -o jsonpath='{.spec.containers[0].securityContext.runAsUser}' 2>/dev/null)
if [ "$user" = "2000" ]; then
  echo "Success: runAsUser is 2000"
  exit 0
fi
echo "Error: runAsUser is '$user', expected 2000"
exit 1
