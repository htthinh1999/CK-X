#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
uid=$(kubectl -n ledger get cronjob reconcile -o jsonpath='{.metadata.uid}' 2>/dev/null)
[ -n "$uid" ] || { echo "ERR: cronjob reconcile not found in ledger"; exit 1; }
j=$(kubectl -n ledger get job reconcile-manual-01 -o json 2>/dev/null) || { echo "ERR: job reconcile-manual-01 not found in ledger"; exit 1; }
own=$(echo "$j" | jq -r --arg u "$uid" '[.metadata.ownerReferences[]? | select(.kind=="CronJob" and .name=="reconcile" and .uid==$u)] | length')
[ "${own:-0}" -ge 1 ] && { echo "OK: job reconcile-manual-01 was created from cronjob reconcile"; exit 0; }
echo "ERR: job reconcile-manual-01 is not owned by cronjob reconcile (use --from=cronjob/reconcile)"; exit 1
