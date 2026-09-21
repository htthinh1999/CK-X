#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod secure-pod -n eclipse -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}' 2>/dev/null)
if [ "$val" == "false" ]; then
  echo "Success: allowPrivilegeEscalation is false"
  exit 0
else
  echo "Error: allowPrivilegeEscalation is '$val', expected false"
  exit 1
fi
