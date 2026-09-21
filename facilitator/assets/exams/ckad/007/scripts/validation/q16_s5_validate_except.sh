#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy external-access -n wave -o yaml 2>/dev/null | grep -q "except"; then echo "Success: except present"; exit 0; else echo "Error: except present - not found"; exit 1; fi
