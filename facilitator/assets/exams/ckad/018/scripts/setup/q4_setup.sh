#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace sonata --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete serviceaccount vault-accessor -n sonata --ignore-not-found=true 2>/dev/null || true
mkdir -p /tmp/exam/course/4
echo "Setup complete for Question 4"
exit 0
