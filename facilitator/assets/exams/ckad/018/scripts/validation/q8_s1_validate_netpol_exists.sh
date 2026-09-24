#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy egress-external-only -n verse >/dev/null 2>&1; then
  echo "Success: networkpolicy egress-external-only exists"; exit 0
fi
echo "Error: networkpolicy egress-external-only not found in verse"; exit 1
