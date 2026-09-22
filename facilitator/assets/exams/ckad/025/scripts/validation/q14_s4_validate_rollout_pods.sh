#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=calibration
DEP=lens-calibrator

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in namespace $NS"; exit 1; }

echo "$json" | jq -e '
  .spec.replicas == 2
  and (.status.observedGeneration // 0) >= .metadata.generation
  and (.status.updatedReplicas // 0) == 2
  and (.status.readyReplicas // 0) == 2' >/dev/null \
  || { echo "FAIL: rollout of $DEP not complete (want 2 updated and 2 ready replicas): $(echo "$json" | jq -c '{spec: .spec.replicas, status: (.status | {updatedReplicas, readyReplicas, replicas})}')"; exit 1; }

sel=$(echo "$json" | jq -r '.spec.selector.matchLabels | to_entries | map("\(.key)=\(.value)") | join(",")')
pods=$(kubectl -n "$NS" get pods -l "$sel" -o json 2>/dev/null \
  | jq -r '.items[] | select(.metadata.deletionTimestamp == null and .status.phase == "Running") | .metadata.name')

ok=0
for p in $pods; do
  v=$(kubectl -n "$NS" exec "$p" -- cat /etc/lens/FILTER 2>/dev/null)
  v="${v%"${v##*[![:space:]]}"}"
  [ "$v" = "h-alpha" ] || { echo "FAIL: pod $p sees /etc/lens/FILTER='$v', expected 'h-alpha'"; exit 1; }
  ok=$((ok + 1))
done
[ "$ok" -ge 2 ] || { echo "FAIL: expected 2 running pods reading the new ConfigMap, found $ok"; exit 1; }

echo "OK: $ok ready pods of $DEP read /etc/lens/FILTER=h-alpha"
exit 0
