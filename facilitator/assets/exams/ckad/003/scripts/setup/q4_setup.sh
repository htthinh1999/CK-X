#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace flare --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
mkdir -p /tmp/exam/course/4
helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
helm repo update 2>/dev/null || true
helm status phoenix-web -n flare >/dev/null 2>&1 || helm install phoenix-web bitnami/nginx -n flare --set service.type=ClusterIP --set replicaCount=1 --wait --timeout 120s 2>/dev/null || true

echo "Setup complete for Question 4"
exit 0
