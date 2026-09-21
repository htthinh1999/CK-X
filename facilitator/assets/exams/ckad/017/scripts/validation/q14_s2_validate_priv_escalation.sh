#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
esc=$(kubectl get pod secure-pod -n abyss -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}' 2>/dev/null)
if [ "$esc" = "false" ]; then
  echo "Success: allowPrivilegeEscalation is false"; exit 0
fi
echo "Error: allowPrivilegeEscalation is '$esc', expected false"; exit 1
