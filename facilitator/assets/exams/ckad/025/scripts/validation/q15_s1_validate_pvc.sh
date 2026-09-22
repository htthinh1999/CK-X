#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=archive
PVC=plate-archive

json=$(kubectl -n "$NS" get pvc "$PVC" -o json 2>/dev/null) || { echo "FAIL: PVC $PVC not found in namespace $NS"; exit 1; }

phase=$(echo "$json" | jq -r '.status.phase // empty')
sc=$(echo "$json" | jq -r '.spec.storageClassName // empty')
req=$(echo "$json" | jq -r '.spec.resources.requests.storage // empty')

[ "$phase" = "Bound" ] || { echo "FAIL: PVC $PVC phase is '$phase', expected Bound"; exit 1; }
[ "$sc" = "local-path" ] || { echo "FAIL: PVC $PVC storageClassName is '$sc', expected local-path"; exit 1; }
[ "$req" = "100Mi" ] || { echo "FAIL: PVC $PVC requests '$req', expected 100Mi"; exit 1; }
echo "$json" | jq -e '(.spec.accessModes // []) | index("ReadWriteOnce") != null' >/dev/null \
  || { echo "FAIL: PVC $PVC access modes do not include ReadWriteOnce"; exit 1; }

echo "OK: PVC $PVC is Bound via local-path (100Mi, RWO)"
exit 0
