#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
a=$(kubectl $CTX -n staging get pod secured -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}' 2>/dev/null)
[ "$a" = "false" ] && { echo "OK"; exit 0; }
echo "ERR: allowPrivilegeEscalation=$a"; exit 1
