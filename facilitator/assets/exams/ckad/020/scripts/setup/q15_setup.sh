#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

# Cluster-scoped RBAC question; no namespace prerequisites needed.
# Clean up any leftover ClusterRoles from a previous attempt.
kubectl delete clusterrole monitor-viewer aggregated-monitor >/dev/null 2>&1 || true

echo "Setup complete for Question 15"
exit 0
