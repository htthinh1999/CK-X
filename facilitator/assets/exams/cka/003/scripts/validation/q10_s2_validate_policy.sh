#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
cp=$(kubectl $CTX -n beta get cronjob report -o jsonpath='{.spec.concurrencyPolicy}' 2>/dev/null)
[ "$cp" = "Forbid" ] && { echo "OK: concurrencyPolicy Forbid"; exit 0; }
echo "ERR: concurrencyPolicy=$cp, expected Forbid"; exit 1
