#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace prod --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n prod delete networkpolicy allow-web --ignore-not-found=true
echo "Setup complete for Question 12"; exit 0
