#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n dev get job batch >/dev/null 2>&1 || { echo "ERR: job batch not found"; exit 1; }
c=$(kubectl $CTX -n dev get job batch -o jsonpath='{.spec.completions}' 2>/dev/null)
[ "$c" = "3" ] && { echo "OK: completions 3"; exit 0; }
echo "ERR: completions=$c, expected 3"; exit 1
