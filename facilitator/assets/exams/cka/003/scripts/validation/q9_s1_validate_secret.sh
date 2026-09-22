#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
u=$(kubectl $CTX -n beta get secret db-cred -o jsonpath='{.data.username}' 2>/dev/null)
p=$(kubectl $CTX -n beta get secret db-cred -o jsonpath='{.data.password}' 2>/dev/null)
[ -n "$u" ] && [ -n "$p" ] && { echo "OK: secret has username+password"; exit 0; }
echo "ERR: secret db-cred missing username/password keys"; exit 1
