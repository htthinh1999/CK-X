#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl get deploy web-deploy -n reef -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
if [ "$s" = "50%" ] || [ "$s" = "2" ]; then
  echo "Success: maxSurge is $s"; exit 0
fi
echo "Error: maxSurge is '$s', expected 50%"; exit 1
