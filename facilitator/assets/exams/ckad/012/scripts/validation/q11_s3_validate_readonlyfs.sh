#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment secure-app -n fortress -o jsonpath='{.spec.template.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)
if [ "$val" = "true" ]; then
  echo "Success: readOnlyRootFilesystem preserved ($val)"
  exit 0
else
  echo "Error: readOnlyRootFilesystem preserved - got '$val', expected 'true'"
  exit 1
fi
