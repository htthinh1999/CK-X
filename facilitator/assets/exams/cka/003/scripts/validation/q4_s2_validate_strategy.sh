#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
mu=$(kubectl $CTX -n alpha get deployment payments -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)
ms=$(kubectl $CTX -n alpha get deployment payments -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
[ "$mu" = "1" ] && [ "$ms" = "1" ] && { echo "OK: rollingUpdate 1/1"; exit 0; }
echo "ERR: maxUnavailable=$mu maxSurge=$ms, expected 1/1"; exit 1
