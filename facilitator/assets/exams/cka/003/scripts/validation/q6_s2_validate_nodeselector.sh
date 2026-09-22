#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
s=$(kubectl $CTX -n alpha get pod pinned -o jsonpath='{.spec.nodeSelector.disk}' 2>/dev/null)
[ "$s" = "ssd" ] && { echo "OK: nodeSelector disk=ssd"; exit 0; }
echo "ERR: nodeSelector disk=$s, expected ssd"; exit 1
