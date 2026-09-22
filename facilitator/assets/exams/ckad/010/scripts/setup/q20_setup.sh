#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace blessing --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

mkdir -p /tmp/exam/course/20 || true
chown -R candidate:candidate /tmp/exam 2>/dev/null || true

echo "Setup complete for Question 20"
exit 0
