#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
s=$(kubectl $CTX -n prod get svc store-svc -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$s" = "store" ] && { echo "OK: selector app=store"; exit 0; }
echo "ERR: selector app=$s, expected store"; exit 1
