#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy egress-policy -n athena >/dev/null 2>&1; then echo "Success: networkpolicy egress-policy exists"; exit 0; else echo "Error: networkpolicy egress-policy not found in athena"; exit 1; fi
