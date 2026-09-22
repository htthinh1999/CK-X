#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
r=$(kubectl $CTX -n staging get deployment rollme -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "${r:-0}" -ge 2 ] 2>/dev/null && { echo "OK"; exit 0; }
echo "ERR: readyReplicas=${r:-0}"; exit 1
