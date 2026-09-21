#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
exc=$(kubectl get netpol egress-external-only -n verse -o jsonpath='{.spec.egress[0].to[0].ipBlock.except}' 2>/dev/null)
if [[ -n "$exc" ]]; then
  echo "Success: egress ipBlock has except block ($exc)"; exit 0
fi
echo "Error: egress ipBlock has no except block"; exit 1
