#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=cargo
json=$(kubectl -n "$NS" get pvc ledger-claim -o json 2>/dev/null) || { echo "FAIL: pvc ledger-claim not found in $NS"; exit 1; }

phase=$(echo "$json" | jq -r '.status.phase // empty')
vol=$(echo "$json" | jq -r '.spec.volumeName // empty')
sc=$(echo "$json" | jq -r '.spec.storageClassName // empty')
modes=$(echo "$json" | jq -r '(.spec.accessModes // []) | sort | join(",")')

[ "$sc" = "manual" ] || { echo "FAIL: ledger-claim storageClassName='$sc' (expected manual)"; exit 1; }
[ "$modes" = "ReadWriteOnce" ] || { echo "FAIL: ledger-claim accessModes='$modes' (expected ReadWriteOnce)"; exit 1; }
[ "$phase" = "Bound" ] || { echo "FAIL: ledger-claim phase='$phase' (expected Bound)"; exit 1; }
[ "$vol" = "ledger-pv" ] || { echo "FAIL: ledger-claim is bound to '$vol' (expected ledger-pv)"; exit 1; }

echo "OK: ledger-claim is Bound to ledger-pv"
exit 0
