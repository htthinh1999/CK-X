#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Setup for Question 13: ClusterRole and ClusterRoleBinding

# Create the cluster-admin namespace referenced by the question if it doesn't exist already
kubectl create namespace cluster-admin --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

echo "Setup complete for Question 13: Environment ready for creating ClusterRole 'pod-reader' and ClusterRoleBinding 'read-pods'"
exit 0
