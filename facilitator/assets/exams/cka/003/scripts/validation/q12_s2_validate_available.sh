#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
r=$(kubectl $CTX -n alpha get deployment legacy -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "${r:-0}" -ge 1 ] 2>/dev/null && { echo "OK: legacy has ready replicas"; exit 0; }
echo "ERR: legacy readyReplicas=${r:-0}"; exit 1
