#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

k=$(kubectl get pod tolerate-pod -n moss -o jsonpath='{.spec.tolerations[?(@.key=="tier")].key}' 2>/dev/null)
if [ "$k" = "tier" ]; then
  echo "Success: toleration key tier correct"; exit 0
else
  echo "Error: toleration key is '$k', expected tier"; exit 1
fi
