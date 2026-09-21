#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get deployment api-server-green -n rampart >/dev/null 2>&1 && { echo "Success: deployment api-server-green exists"; exit 0; }
echo "Error: deployment api-server-green not found"; exit 1
