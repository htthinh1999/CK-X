#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
u=$(kubectl get deploy web-deploy -n reef -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)
if [ "$u" = "25%" ] || [ "$u" = "1" ]; then
  echo "Success: maxUnavailable is $u"; exit 0
fi
echo "Error: maxUnavailable is '$u', expected 25%"; exit 1
