#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace voltage --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete deployment api-gateway -n voltage --ignore-not-found=true >/dev/null 2>&1 || true
# Revision 1: good image nginx:1.23 (container is named "nginx" by kubectl create)
kubectl create deployment api-gateway --image=nginx:1.23 -n voltage
kubectl rollout status deployment/api-gateway -n voltage --timeout=90s || true
# Revision 2: broken image -> current state is broken
kubectl set image deployment/api-gateway nginx=nginx:broken-tag-123 -n voltage
kubectl rollout status deployment/api-gateway -n voltage --timeout=20s || true
echo "Setup complete for Question 17"
exit 0
