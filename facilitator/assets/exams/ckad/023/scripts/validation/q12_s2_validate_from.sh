#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
f=$(kubectl $CTX -n prod get networkpolicy allow-web -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}' 2>/dev/null)
[ "$f" = "client" ] && { echo "OK: ingress from app=client"; exit 0; }
echo "ERR: ingress from app=$f, expected client"; exit 1
