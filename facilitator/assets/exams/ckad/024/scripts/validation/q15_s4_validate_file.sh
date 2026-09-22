#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=cargo
kubectl -n "$NS" get pod ledger-writer >/dev/null 2>&1 || { echo "FAIL: pod ledger-writer not found in $NS"; exit 1; }

out=$(kubectl -n "$NS" exec ledger-writer -- cat /ledger/entry.txt 2>/dev/null)
if echo "$out" | grep -q 'manifest=sealed'; then
  echo "OK: /ledger/entry.txt contains manifest=sealed"
  exit 0
fi
echo "FAIL: /ledger/entry.txt in ledger-writer does not contain manifest=sealed (got '$out')"
exit 1
