#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy external-access -n wave >/dev/null 2>&1; then echo "Success: networkpolicy external-access exists in wave"; exit 0; else echo "Error: networkpolicy external-access not found in wave"; exit 1; fi
