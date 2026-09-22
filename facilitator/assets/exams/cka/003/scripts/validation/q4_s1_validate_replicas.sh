#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
r=$(kubectl $CTX -n alpha get deployment payments -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$r" = "5" ] && { echo "OK: 5 replicas"; exit 0; }
echo "ERR: replicas=$r, expected 5"; exit 1
