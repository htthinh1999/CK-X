#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get networkpolicy egress-policy -n athena -o jsonpath='{.spec.policyTypes}' 2>/dev/null)
case "$v" in *Egress*) echo "Success: Egress policy type configured"; exit 0;; *) echo "Error: policyTypes is '$v', expected to include Egress"; exit 1;; esac
