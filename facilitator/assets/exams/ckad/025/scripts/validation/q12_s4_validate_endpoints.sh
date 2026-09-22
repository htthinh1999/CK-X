#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=orbit; SVC=telemetry

ep=$(kubectl -n "$NS" get endpoints "$SVC" -o json 2>/dev/null) || { echo "FAIL: Endpoints $SVC not found in $NS"; exit 1; }

total=$(echo "$ep" | jq '[.subsets[]?.addresses[]?] | length')
canary=$(echo "$ep" | jq '[.subsets[]?.addresses[]? | select((.targetRef.name // "") | startswith("telemetry-canary-"))] | length')

if [ "$total" = "3" ] && [ "$canary" = "0" ]; then
  echo "PASS: Service $SVC routes to exactly the 3 stable pods"
  exit 0
fi
echo "FAIL: expected 3 ready stable endpoints and no canary endpoints (total=$total canary=$canary)"
exit 1
