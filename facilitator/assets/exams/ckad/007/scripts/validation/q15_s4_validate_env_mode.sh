#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment patch-demo -n tide -o yaml 2>/dev/null | grep -q "production"; then echo "Success: ENV_MODE production"; exit 0; else echo "Error: ENV_MODE production - not found"; exit 1; fi
