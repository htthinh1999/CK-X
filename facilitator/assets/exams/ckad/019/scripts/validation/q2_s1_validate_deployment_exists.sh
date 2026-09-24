#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get deployment vanguard-web -n vanguard >/dev/null 2>&1 && { echo "Success: deployment vanguard-web exists"; exit 0; }
echo "Error: deployment vanguard-web not found"; exit 1
