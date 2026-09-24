#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get pod db-consumer -n citadel >/dev/null 2>&1 && { echo "Success: pod db-consumer exists"; exit 0; }
echo "Error: pod db-consumer not found"; exit 1
