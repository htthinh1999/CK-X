#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n beta get cronjob report >/dev/null 2>&1 || { echo "ERR: cronjob report not found"; exit 1; }
sc=$(kubectl $CTX -n beta get cronjob report -o jsonpath='{.spec.schedule}' 2>/dev/null)
[ "$sc" = "*/5 * * * *" ] && { echo "OK: schedule */5 * * * *"; exit 0; }
echo "ERR: schedule='$sc', expected '*/5 * * * *'"; exit 1
