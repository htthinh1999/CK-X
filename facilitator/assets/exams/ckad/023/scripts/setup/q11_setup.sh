#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace prod --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n prod delete cronjob backup --ignore-not-found=true
echo "Setup complete for Question 11"; exit 0
