#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod secure-pod -n ancient -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}' 2>/dev/null)
if [ "$val" = "false" ]; then
  echo "Success: allowPrivilegeEscalation is false"
  exit 0
fi
echo "Error: allowPrivilegeEscalation is '$val', expected false"
exit 1
