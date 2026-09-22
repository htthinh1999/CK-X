#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment safe-deploy -n fang >/dev/null 2>&1; then echo "Success: deployment safe-deploy exists"; exit 0; else echo "Error: deployment safe-deploy not found"; exit 1; fi
