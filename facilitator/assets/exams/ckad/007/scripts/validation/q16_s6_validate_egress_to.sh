#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy external-access -n wave -o jsonpath='{.spec.egress}' 2>/dev/null | grep -q "to"; then echo "Success: egress to"; exit 0; else echo "Error: egress to - not found"; exit 1; fi
