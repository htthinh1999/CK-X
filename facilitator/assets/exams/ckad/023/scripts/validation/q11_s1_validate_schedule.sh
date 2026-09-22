#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n prod get cronjob backup >/dev/null 2>&1 || { echo "ERR: cronjob backup not found"; exit 1; }
s=$(kubectl $CTX -n prod get cronjob backup -o jsonpath='{.spec.schedule}' 2>/dev/null)
[ "$s" = "0 */6 * * *" ] && { echo "OK: schedule 0 */6 * * *"; exit 0; }
echo "ERR: schedule='$s', expected '0 */6 * * *'"; exit 1
