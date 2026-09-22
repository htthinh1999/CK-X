#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
r=$(kubectl $CTX -n dev get deployment rollme -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "${r:-0}" -ge 2 ] 2>/dev/null && { echo "OK: rollme ready"; exit 0; }
echo "ERR: rollme readyReplicas=${r:-0}, expected 2"; exit 1
