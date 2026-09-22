#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
r=$(kubectl $CTX -n alpha get deployment web -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$r" = "3" ] && { echo "OK: 3 replicas"; exit 0; }
echo "ERR: replicas=$r, expected 3"; exit 1
