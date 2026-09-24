#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=wharf
json=$(kubectl -n "$NS" get limitrange crate-defaults -o json 2>/dev/null) || { echo "FAIL: limitrange crate-defaults not found in $NS"; exit 1; }

item=$(echo "$json" | jq -c '[.spec.limits[]? | select(.type == "Container")][0] // empty')
[ -n "$item" ] || { echo "FAIL: crate-defaults has no limit of type Container"; exit 1; }

rc=$(echo "$item" | jq -r '.defaultRequest.cpu // empty')
rmem=$(echo "$item" | jq -r '.defaultRequest.memory // empty')
lc=$(echo "$item" | jq -r '.default.cpu // empty')
lm=$(echo "$item" | jq -r '.default.memory // empty')

[ "$rc" = "50m" ] && [ "$rmem" = "64Mi" ] || { echo "FAIL: defaultRequest cpu=$rc memory=$rmem (expected 50m / 64Mi)"; exit 1; }
[ "$lc" = "100m" ] && [ "$lm" = "128Mi" ] || { echo "FAIL: default (limits) cpu=$lc memory=$lm (expected 100m / 128Mi)"; exit 1; }

echo "OK: crate-defaults sets container defaults requests 50m/64Mi, limits 100m/128Mi"
exit 0
