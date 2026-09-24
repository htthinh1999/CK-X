#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get service external-db -n outpost >/dev/null 2>&1 && { echo "Success: service external-db exists"; exit 0; }
echo "Error: service external-db not found"; exit 1
