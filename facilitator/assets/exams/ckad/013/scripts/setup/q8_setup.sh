#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace radiance --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true
helm status web-release -n radiance >/dev/null 2>&1 || \
  helm install web-release bitnami/nginx -n radiance --set replicaCount=1 --set service.type=ClusterIP --wait --timeout 120s >/dev/null 2>&1 || true
echo "Setup complete for Question 8"
exit 0
