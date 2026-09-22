#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
a=$(kubectl $CTX -n prod get secret app-secret -o jsonpath='{.data.api-key}' 2>/dev/null)
t=$(kubectl $CTX -n prod get secret app-secret -o jsonpath='{.data.token}' 2>/dev/null)
[ -n "$a" ] && [ -n "$t" ] && { echo "OK: secret has api-key + token"; exit 0; }
echo "ERR: secret app-secret missing api-key/token"; exit 1
