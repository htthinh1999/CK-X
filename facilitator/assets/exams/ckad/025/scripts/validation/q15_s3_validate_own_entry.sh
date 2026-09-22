#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=archive
DEP=plate-scanner

sel=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null \
  | jq -r '.spec.selector.matchLabels // {} | to_entries | map("\(.key)=\(.value)") | join(",")')
[ -n "$sel" ] || { echo "FAIL: Deployment $DEP not found in namespace $NS"; exit 1; }

pods=$(kubectl -n "$NS" get pods -l "$sel" -o json 2>/dev/null \
  | jq -r '.items[] | select(.metadata.deletionTimestamp == null and .status.phase == "Running") | .metadata.name')
[ -n "$pods" ] || { echo "FAIL: no running pod of $DEP"; exit 1; }

for p in $pods; do
  content=$(kubectl -n "$NS" exec "$p" -c scanner -- cat /archive/scans.log 2>/dev/null)
  if echo "$content" | grep -qE "^scanned-by ${p}[[:space:]]*$"; then
    echo "OK: pod $p wrote its own entry to /archive/scans.log"
    exit 0
  fi
done

echo "FAIL: /archive/scans.log in the running pod does not contain 'scanned-by <pod name>'"
exit 1
