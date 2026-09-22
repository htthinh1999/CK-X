#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy external-access -n wave -o yaml 2>/dev/null | grep -q "443"; then echo "Success: port 443"; exit 0; else echo "Error: port 443 - not found"; exit 1; fi
