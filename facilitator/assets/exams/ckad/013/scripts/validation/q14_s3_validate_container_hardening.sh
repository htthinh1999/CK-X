#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ro=$(kubectl get deploy hardened-app -n dawn -o jsonpath='{.spec.template.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)
dc=$(kubectl get deploy hardened-app -n dawn -o jsonpath='{.spec.template.spec.containers[0].securityContext.capabilities.drop}' 2>/dev/null)
if [ "$ro" = "true" ] && [[ "$dc" == *"ALL"* ]]; then
  echo "Success: readOnlyRootFilesystem true and drop ALL"
  exit 0
else
  echo "Error: readOnly='$ro' drop='$dc'"
  exit 1
fi
