#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
surge=$(kubectl get deploy rolling-deploy -n sonata -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
unav=$(kubectl get deploy rolling-deploy -n sonata -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)
if [ "$surge" == "40%" ] && [ "$unav" == "20%" ]; then
  echo "Success: maxSurge=40% maxUnavailable=20%"; exit 0
fi
echo "Error: maxSurge='$surge' maxUnavailable='$unav', expected 40%/20%"; exit 1
