#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
p_user=$(kubectl get pod secure-pod -n guardian -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)
if [[ "$p_user" == "1000" ]]; then
  echo "Success: pod-level runAsUser is 1000"
  exit 0
fi
echo "Error: pod-level runAsUser is '$p_user', expected 1000"
exit 1
