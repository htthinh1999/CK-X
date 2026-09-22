#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl get cj data-sync -n coral -o jsonpath='{.spec.suspend}' 2>/dev/null)
if [ "$s" = "true" ]; then
  echo "Success: suspend is true"; exit 0
fi
echo "Error: suspend is '$s', expected true"; exit 1
