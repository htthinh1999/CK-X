#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy external-access -n wave -o yaml 2>/dev/null | grep -q "53"; then echo "Success: port 53"; exit 0; else echo "Error: port 53 - not found"; exit 1; fi
