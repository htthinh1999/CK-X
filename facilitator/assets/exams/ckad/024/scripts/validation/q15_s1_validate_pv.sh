#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
json=$(kubectl get pv ledger-pv -o json 2>/dev/null) || { echo "FAIL: persistentvolume ledger-pv not found"; exit 1; }

sc=$(echo "$json" | jq -r '.spec.storageClassName // empty')
cap=$(echo "$json" | jq -r '.spec.capacity.storage // empty')
modes=$(echo "$json" | jq -r '(.spec.accessModes // []) | sort | join(",")')
hp=$(echo "$json" | jq -r '.spec.hostPath.path // empty')
hp="${hp%/}"

[ "$sc" = "manual" ] || { echo "FAIL: ledger-pv storageClassName='$sc' (expected manual)"; exit 1; }
[ "$cap" = "200Mi" ] || { echo "FAIL: ledger-pv capacity='$cap' (expected 200Mi)"; exit 1; }
[ "$modes" = "ReadWriteOnce" ] || { echo "FAIL: ledger-pv accessModes='$modes' (expected ReadWriteOnce)"; exit 1; }
[ "$hp" = "/tmp/cargo-ledger" ] || { echo "FAIL: ledger-pv hostPath='$hp' (expected /tmp/cargo-ledger)"; exit 1; }

echo "OK: ledger-pv is a 200Mi RWO hostPath PV in class manual"
exit 0
