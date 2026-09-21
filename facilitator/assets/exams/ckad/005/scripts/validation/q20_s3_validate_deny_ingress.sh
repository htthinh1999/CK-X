#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get networkpolicy default-deny-all -n predator -o jsonpath='{.spec.policyTypes[*]}' 2>/dev/null)
if echo "$v" | grep -q "Ingress"; then echo "Success: denies Ingress"; exit 0; else echo "Error: policyTypes missing Ingress"; exit 1; fi
