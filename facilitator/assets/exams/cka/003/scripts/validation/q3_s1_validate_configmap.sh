#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
m=$(kubectl $CTX -n alpha get configmap app-config -o jsonpath='{.data.APP_MODE}' 2>/dev/null)
x=$(kubectl $CTX -n alpha get configmap app-config -o jsonpath='{.data.MAX}' 2>/dev/null)
[ "$m" = "prod" ] && [ "$x" = "10" ] && { echo "OK: configmap keys correct"; exit 0; }
echo "ERR: APP_MODE=$m MAX=$x, expected prod/10"; exit 1
