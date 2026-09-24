#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod secure-pod -n ancient -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)
if [ "$val" = "true" ]; then
  echo "Success: readOnlyRootFilesystem is true"
  exit 0
fi
echo "Error: readOnlyRootFilesystem is '$val', expected true"
exit 1
