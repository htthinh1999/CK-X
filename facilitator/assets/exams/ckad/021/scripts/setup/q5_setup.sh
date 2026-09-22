#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace haven --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/5
[ -d /tmp/guardian-app ] || helm create /tmp/guardian-app >/dev/null 2>&1
helm status guardian-app -n haven >/dev/null 2>&1 || helm install guardian-app /tmp/guardian-app -n haven --set replicaCount=1 --set image.tag=1.16.0 >/dev/null 2>&1 || true
echo "Setup complete for Question 5"
exit 0
