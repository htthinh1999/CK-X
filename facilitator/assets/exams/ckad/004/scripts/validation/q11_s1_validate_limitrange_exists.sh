#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get limitrange resource-limits -n apollo >/dev/null 2>&1; then echo "Success: limitrange resource-limits exists"; exit 0; else echo "Error: limitrange resource-limits not found"; exit 1; fi
