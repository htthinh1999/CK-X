#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n prod get deployment store >/dev/null 2>&1 || { echo "ERR: deployment store not found"; exit 1; }
r=$(kubectl $CTX -n prod get deployment store -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$r" = "2" ] && { echo "OK: store 2 replicas"; exit 0; }
echo "ERR: store replicas=$r, expected 2"; exit 1
