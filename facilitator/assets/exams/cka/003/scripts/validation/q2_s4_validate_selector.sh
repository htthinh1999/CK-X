#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
s=$(kubectl $CTX -n alpha get svc cache-svc -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$s" = "cache" ] && { echo "OK: selector app=cache"; exit 0; }
echo "ERR: selector app=$s, expected cache"; exit 1
