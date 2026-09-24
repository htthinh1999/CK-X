#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=cargo
json=$(kubectl -n "$NS" get pod ledger-writer -o json 2>/dev/null) || { echo "FAIL: pod ledger-writer not found in $NS"; exit 1; }

img=$(echo "$json" | jq -r '.spec.containers[0].image // empty')
case "$img" in
  busybox:1.36|docker.io/library/busybox:1.36) ;;
  *) echo "FAIL: ledger-writer image is '$img' (expected busybox:1.36)"; exit 1 ;;
esac

phase=$(echo "$json" | jq -r '.status.phase // empty')
[ "$phase" = "Running" ] || { echo "FAIL: ledger-writer phase='$phase' (expected Running)"; exit 1; }

vols=$(echo "$json" | jq -r '.spec.volumes[]? | select(.persistentVolumeClaim.claimName == "ledger-claim") | .name')
[ -n "$vols" ] || { echo "FAIL: ledger-writer has no volume using pvc ledger-claim"; exit 1; }

for v in $vols; do
  for mp in $(echo "$json" | jq -r --arg v "$v" '.spec.containers[].volumeMounts[]? | select(.name == $v) | .mountPath'); do
    if [ "${mp%/}" = "/ledger" ]; then
      echo "OK: ledger-writer is Running and mounts ledger-claim at /ledger"
      exit 0
    fi
  done
done
echo "FAIL: the ledger-claim volume is not mounted at /ledger"
exit 1
