#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
d=$(kubectl $CTX -n dev get configmap feature-flags -o jsonpath='{.data.DARK_MODE}' 2>/dev/null)
b=$(kubectl $CTX -n dev get configmap feature-flags -o jsonpath='{.data.BETA}' 2>/dev/null)
[ "$d" = "true" ] && [ "$b" = "false" ] && { echo "OK"; exit 0; }
echo "ERR: DARK_MODE=$d BETA=$b"; exit 1
