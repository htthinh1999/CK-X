#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy external-access -n wave -o jsonpath='{.spec.ingress}' 2>/dev/null | grep -q "from"; then echo "Success: ingress from"; exit 0; else echo "Error: ingress from - not found"; exit 1; fi
