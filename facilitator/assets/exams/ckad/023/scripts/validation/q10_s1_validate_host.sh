#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n prod get ingress shop-ing >/dev/null 2>&1 || { echo "ERR: ingress shop-ing not found"; exit 1; }
h=$(kubectl $CTX -n prod get ingress shop-ing -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
[ "$h" = "shop.local" ] && { echo "OK"; exit 0; }
echo "ERR: host=$h"; exit 1
