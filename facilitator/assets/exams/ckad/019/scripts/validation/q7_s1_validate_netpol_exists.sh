#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get networkpolicy protect-db -n vanguard >/dev/null 2>&1 && { echo "Success: networkpolicy protect-db exists"; exit 0; }
echo "Error: networkpolicy protect-db not found"; exit 1
