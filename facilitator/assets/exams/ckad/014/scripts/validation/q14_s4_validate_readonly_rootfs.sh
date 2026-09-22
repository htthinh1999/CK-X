#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod secure-pod -n eclipse -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)
if [ "$val" == "true" ]; then
  echo "Success: readOnlyRootFilesystem is true"
  exit 0
else
  echo "Error: readOnlyRootFilesystem is '$val', expected true"
  exit 1
fi
