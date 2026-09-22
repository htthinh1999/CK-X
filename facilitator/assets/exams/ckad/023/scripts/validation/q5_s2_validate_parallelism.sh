#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
p=$(kubectl $CTX -n staging get job batch -o jsonpath='{.spec.parallelism}' 2>/dev/null)
[ "$p" = "2" ] && { echo "OK"; exit 0; }
echo "ERR: parallelism=$p"; exit 1
