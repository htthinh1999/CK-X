#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n staging get deployment store >/dev/null 2>&1 || { echo "ERR: deployment store not found"; exit 1; }
r=$(kubectl $CTX -n staging get deployment store -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$r" = "2" ] && { echo "OK"; exit 0; }
echo "ERR: replicas=$r"; exit 1
