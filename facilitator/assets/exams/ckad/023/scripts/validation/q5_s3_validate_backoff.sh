#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
b=$(kubectl $CTX -n staging get job batch -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)
[ "$b" = "4" ] && { echo "OK"; exit 0; }
echo "ERR: backoffLimit=$b"; exit 1
