#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace dev --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n dev delete pod limited --ignore-not-found=true
echo "Setup complete for Question 5"; exit 0
