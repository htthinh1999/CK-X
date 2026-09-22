#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n beta get networkpolicy default-deny >/dev/null 2>&1 || { echo "ERR: netpol default-deny not found"; exit 1; }
ps=$(kubectl $CTX -n beta get networkpolicy default-deny -o jsonpath='{.spec.podSelector}' 2>/dev/null)
{ [ "$ps" = "{}" ] || [ "$ps" = "map[]" ]; } && { echo "OK: empty podSelector"; exit 0; }
echo "ERR: podSelector='$ps', expected empty {}"; exit 1
