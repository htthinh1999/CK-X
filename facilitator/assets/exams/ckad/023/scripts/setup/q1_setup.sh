#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace dev --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n dev delete pod sidecar-pod --ignore-not-found=true
echo "Setup complete for Question 1"; exit 0
