#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get deployment citadel-guard -n citadel >/dev/null 2>&1 && { echo "Success: deployment citadel-guard exists"; exit 0; }
echo "Error: deployment citadel-guard not found"; exit 1
