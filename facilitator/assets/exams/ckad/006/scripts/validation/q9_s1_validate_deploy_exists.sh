#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deploy app-v1 -n brook >/dev/null 2>&1; then echo "Success: deployment app-v1 exists"; exit 0; else echo "Error: deployment app-v1 not found in brook"; exit 1; fi
