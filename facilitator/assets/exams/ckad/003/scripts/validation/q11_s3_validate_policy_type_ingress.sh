#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
pt=$(kubectl get networkpolicy allow-from-flame -n corona -o jsonpath='{.spec.policyTypes}' 2>/dev/null)
if echo "$pt" | grep -q "Ingress"; then
  echo "Success: policyTypes includes Ingress"
  exit 0
else
  echo "Error: policyTypes '$pt' missing Ingress"
  exit 1
fi
