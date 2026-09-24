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
  others=$(echo "$content" | awk '$1 == "scanned-by" && NF >= 2 {print $2}' | grep -vxF -- "$p" | sort -u)
  if [ -n "$others" ]; then
    echo "OK: pod $p sees entries written by an earlier pod: $(echo $others)"
    exit 0
  fi
done

echo "FAIL: /archive/scans.log has no entry from a previous pod (delete the first pod so the Deployment replaces it)"
exit 1
