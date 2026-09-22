#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace beta --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n beta delete service api-np --ignore-not-found=true
kubectl $CTX -n beta delete deployment api --ignore-not-found=true
echo "Setup complete for Question 12"
exit 0
