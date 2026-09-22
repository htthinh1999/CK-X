#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
max_s=$(kubectl get deployment eden-api -n eden -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
max_u=$(kubectl get deployment eden-api -n eden -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)
if { [ "$max_s" = "2" ] || [ "$max_s" = "25%" ]; } && { [ "$max_u" = "0" ] || [ "$max_u" = "0%" ]; }; then
  echo "Success: strategy has maxSurge=$max_s maxUnavailable=$max_u"
  exit 0
fi
echo "Error: maxSurge='$max_s' maxUnavailable='$max_u', expected maxSurge 2 and maxUnavailable 0"
exit 1
