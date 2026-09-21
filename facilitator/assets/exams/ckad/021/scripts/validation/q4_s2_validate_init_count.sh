#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
init_count=$(kubectl get pod init-chain -n guardian -o jsonpath='{.spec.initContainers}' 2>/dev/null | grep -o name | wc -l)
if [ "$init_count" -ge 3 ]; then
  echo "Success: $init_count init containers found"
  exit 0
fi
echo "Error: not enough init containers ($init_count)"
exit 1
