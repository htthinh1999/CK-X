#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy external-access -n wave -o yaml 2>/dev/null | grep -q "ipBlock"; then echo "Success: ipBlock present"; exit 0; else echo "Error: ipBlock present - not found"; exit 1; fi
