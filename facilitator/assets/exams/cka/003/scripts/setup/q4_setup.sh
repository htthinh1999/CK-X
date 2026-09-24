#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace alpha --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n alpha delete configmap app-config --ignore-not-found=true
kubectl $CTX -n alpha delete pod config-reader --ignore-not-found=true
echo "Setup complete for Question 4"
exit 0
