#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
b=$(kubectl $CTX -n dev get job batch -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)
[ "$b" = "4" ] && { echo "OK: backoffLimit 4"; exit 0; }
echo "ERR: backoffLimit=$b, expected 4"; exit 1
