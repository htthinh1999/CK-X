#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy port-range-allow -n chorus >/dev/null 2>&1; then
  echo "Success: networkpolicy port-range-allow exists"; exit 0
fi
echo "Error: networkpolicy port-range-allow not found in chorus"; exit 1
