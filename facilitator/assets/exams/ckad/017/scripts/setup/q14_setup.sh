#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace current --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true
if ! helm status ocean-api -n current >/dev/null 2>&1; then
  helm install ocean-api bitnami/nginx -n current --set service.type=ClusterIP --set replicaCount=1 --wait --timeout 120s >/dev/null 2>&1 || \
  helm install ocean-api bitnami/nginx -n current >/dev/null 2>&1 || true
fi
echo "Setup complete for Question 14"
exit 0
