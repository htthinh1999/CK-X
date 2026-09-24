#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace staging --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n staging delete job batch --ignore-not-found=true
echo "Setup complete for Question 4"; exit 0
