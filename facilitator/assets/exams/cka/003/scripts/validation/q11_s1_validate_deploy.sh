#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n beta get deployment api >/dev/null 2>&1 || { echo "ERR: deployment api not found"; exit 1; }
r=$(kubectl $CTX -n beta get deployment api -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$r" = "2" ] && { echo "OK: api 2 replicas"; exit 0; }
echo "ERR: api replicas=$r, expected 2"; exit 1
