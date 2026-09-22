#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get resourcequota namespace-limits -n shell >/dev/null 2>&1; then echo "Success: resourcequota namespace-limits exists in shell"; exit 0; else echo "Error: resourcequota namespace-limits not found in shell"; exit 1; fi
