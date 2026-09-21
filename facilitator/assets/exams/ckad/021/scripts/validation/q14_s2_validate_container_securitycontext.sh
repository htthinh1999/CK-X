#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c_user=$(kubectl get pod secure-pod -n guardian -o jsonpath='{.spec.containers[0].securityContext.runAsUser}' 2>/dev/null)
if [[ "$c_user" == "2000" ]]; then
  echo "Success: container-level runAsUser is 2000"
  exit 0
fi
echo "Error: container-level runAsUser is '$c_user', expected 2000"
exit 1
