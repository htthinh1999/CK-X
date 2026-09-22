#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
u=$(kubectl $CTX -n staging get pod secured -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)
[ -z "$u" ] && u=$(kubectl $CTX -n staging get pod secured -o jsonpath='{.spec.containers[0].securityContext.runAsUser}' 2>/dev/null)
[ "$u" = "1000" ] && { echo "OK"; exit 0; }
echo "ERR: runAsUser=$u"; exit 1
