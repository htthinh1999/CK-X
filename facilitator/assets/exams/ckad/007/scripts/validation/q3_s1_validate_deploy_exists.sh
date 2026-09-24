#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment patch-demo -n tide >/dev/null 2>&1; then echo "Success: deployment patch-demo exists in tide"; exit 0; else echo "Error: deployment patch-demo not found in tide"; exit 1; fi
