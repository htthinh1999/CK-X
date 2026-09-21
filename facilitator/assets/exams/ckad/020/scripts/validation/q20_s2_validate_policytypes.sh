#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
types=$(kubectl get networkpolicy isolate-namespace -n nexus -o jsonpath='{.spec.policyTypes}' 2>/dev/null)
if [[ "$types" == *"Ingress"* && "$types" == *"Egress"* ]]; then
  echo "Success: policyTypes includes Ingress and Egress"
  exit 0
fi
echo "Error: policyTypes is '$types', expected to include Ingress and Egress"
exit 1
