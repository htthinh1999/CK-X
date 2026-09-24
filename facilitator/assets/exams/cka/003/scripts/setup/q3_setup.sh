#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace beta --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n beta delete pod writer --ignore-not-found=true
kubectl $CTX -n beta delete pvc data --ignore-not-found=true
echo "Setup complete for Question 3"
exit 0
