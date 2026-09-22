#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
a=$(kubectl $CTX -n dev get pod secured -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}' 2>/dev/null)
[ "$a" = "false" ] && { echo "OK: allowPrivilegeEscalation false"; exit 0; }
echo "ERR: allowPrivilegeEscalation=$a, expected false"; exit 1
