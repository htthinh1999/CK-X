#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=dispatch
DEP=dispatch-board

dep=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found in $NS"; exit 1; }
sel=$(echo "$dep" | jq -r '.spec.selector.matchLabels | to_entries | map("\(.key)=\(.value)") | join(",")')
pods=$(kubectl -n "$NS" get pods -l "$sel" -o json 2>/dev/null | jq -r '.items[]
  | select(.metadata.deletionTimestamp == null and .status.phase == "Running")
  | select([.status.conditions[]? | select(.type=="Ready" and .status=="True")] | length > 0)
  | .metadata.name')
n=$(echo "$pods" | sed '/^$/d' | wc -l)
[ "$n" -ge 2 ] || { echo "ERR: expected 2 ready $DEP pods, found $n"; exit 1; }

for p in $pods; do
  page=$(timeout 15 kubectl -n "$NS" exec "$p" -c board -- cat /usr/share/nginx/html/index.html 2>/dev/null) \
    || { echo "ERR: cannot read the page in pod $p"; exit 1; }
  echo "$page" | grep -q 'zone=riverside build=417' \
    || { echo "ERR: pod $p serves '$(echo "$page" | grep -o 'zone=[^<]*' | head -1)', expected 'zone=riverside build=417'"; exit 1; }
done

echo "OK: all $n ready pods serve zone=riverside build=417"
exit 0
