#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deploy web-app-canary -n default >/dev/null 2>&1; then echo "Success: deployment web-app-canary exists"; exit 0; else echo "Error: deployment web-app-canary not found"; exit 1; fi
