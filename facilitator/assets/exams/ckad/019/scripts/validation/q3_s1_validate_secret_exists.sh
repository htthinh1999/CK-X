#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get secret db-credentials -n citadel >/dev/null 2>&1 && { echo "Success: secret db-credentials exists"; exit 0; }
echo "Error: secret db-credentials not found"; exit 1
