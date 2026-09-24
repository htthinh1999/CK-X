#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl -n ledger get job reconcile-manual-01 -o jsonpath='{.status.succeeded}' 2>/dev/null)
[ "${s:-0}" -ge 1 ] 2>/dev/null || { echo "ERR: job reconcile-manual-01 has not completed successfully (succeeded=${s:-0})"; exit 1; }
out=$(kubectl -n ledger logs job/reconcile-manual-01 --tail=20 2>/dev/null)
echo "$out" | grep -q "uid=2500" && { echo "OK: job completed and ran as uid 2500"; exit 0; }
echo "ERR: job log does not show uid=2500 (got: ${out:-<no logs>})"; exit 1
