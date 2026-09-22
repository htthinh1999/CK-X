#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
r=$(kubectl $CTX -n alpha get deployment web -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "${r:-0}" -ge 3 ] 2>/dev/null && { echo "OK: 3 ready"; exit 0; }
echo "ERR: readyReplicas=${r:-0}, expected 3"; exit 1
