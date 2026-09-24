#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace prod --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n prod delete pod secret-consumer --ignore-not-found=true
kubectl $CTX -n prod delete secret app-secret --ignore-not-found=true
echo "Setup complete for Question 1"; exit 0
