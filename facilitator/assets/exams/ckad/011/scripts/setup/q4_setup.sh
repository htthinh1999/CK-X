#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Prerequisite: helm release rollback-app must already exist with 2 revisions.
kubectl create namespace wave --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true

if ! helm status rollback-app -n wave >/dev/null 2>&1; then
  # Revision 1
  helm install rollback-app bitnami/nginx -n wave \
    --set replicaCount=1 --set service.type=ClusterIP \
    --wait --timeout 120s >/dev/null 2>&1 || true
  # Revision 2
  helm upgrade rollback-app bitnami/nginx -n wave \
    --set replicaCount=2 --set service.type=ClusterIP \
    --wait --timeout 120s >/dev/null 2>&1 || true
fi

echo "Setup complete for Question 4"
exit 0
