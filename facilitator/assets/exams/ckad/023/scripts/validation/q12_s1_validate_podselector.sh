#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n prod get networkpolicy allow-web >/dev/null 2>&1 || { echo "ERR: netpol allow-web not found"; exit 1; }
a=$(kubectl $CTX -n prod get networkpolicy allow-web -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
[ "$a" = "web" ] && { echo "OK: podSelector app=web"; exit 0; }
echo "ERR: podSelector app=$a, expected web"; exit 1
