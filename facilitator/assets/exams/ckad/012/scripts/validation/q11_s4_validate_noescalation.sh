#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment secure-app -n fortress -o jsonpath='{.spec.template.spec.containers[0].securityContext.allowPrivilegeEscalation}' 2>/dev/null)
if [ "$val" = "false" ]; then
  echo "Success: allowPrivilegeEscalation preserved ($val)"
  exit 0
else
  echo "Error: allowPrivilegeEscalation preserved - got '$val', expected 'false'"
  exit 1
fi
