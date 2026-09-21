#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy hardened-app -n dawn -o jsonpath='{.spec.template.spec.securityContext.runAsNonRoot}' 2>/dev/null)
if [ "$v" = "true" ]; then
  echo "Success: runAsNonRoot true"
  exit 0
else
  echo "Error: runAsNonRoot is '$v'"
  exit 1
fi
