#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get networkpolicy default-deny-all -n predator -o jsonpath='{.spec.policyTypes[*]}' 2>/dev/null)
if echo "$v" | grep -q "Egress"; then echo "Success: denies Egress"; exit 0; else echo "Error: policyTypes missing Egress"; exit 1; fi
