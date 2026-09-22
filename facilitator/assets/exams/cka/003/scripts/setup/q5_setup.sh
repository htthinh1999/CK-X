#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace alpha --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n alpha delete rolebinding deployer-binding --ignore-not-found=true
kubectl $CTX -n alpha delete role deployer-role --ignore-not-found=true
kubectl $CTX -n alpha delete serviceaccount deployer --ignore-not-found=true
echo "Setup complete for Question 5"
exit 0
