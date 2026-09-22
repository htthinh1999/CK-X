#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
s=$(kubectl $CTX -n beta get pvc data -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
[ "$s" = "1Gi" ] && { echo "OK: 1Gi"; exit 0; }
echo "ERR: size=$s, expected 1Gi"; exit 1
