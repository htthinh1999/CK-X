#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
t=$(kubectl $CTX -n alpha get svc cache-svc -o jsonpath='{.spec.type}' 2>/dev/null)
[ "$t" = "ClusterIP" ] && { echo "OK: ClusterIP"; exit 0; }
echo "ERR: type=$t, expected ClusterIP"; exit 1
