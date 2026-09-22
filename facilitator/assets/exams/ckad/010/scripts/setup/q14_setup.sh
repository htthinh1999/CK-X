#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"


mkdir -p /tmp/exam/course/14 || true
chown -R candidate:candidate /tmp/exam 2>/dev/null || true
helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true

echo "Setup complete for Question 14"
exit 0
