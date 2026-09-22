#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectro
DEP=prism

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in namespace $NS"; exit 1; }

echo "$json" | jq -e '.spec.replicas == 3 and (.status.readyReplicas // 0) == 3' >/dev/null \
  || { echo "FAIL: Deployment $DEP has $(echo "$json" | jq -r '.status.readyReplicas // 0')/$(echo "$json" | jq -r '.spec.replicas') ready replicas, expected 3/3"; exit 1; }

sel=$(echo "$json" | jq -r '.spec.selector.matchLabels | to_entries | map("\(.key)=\(.value)") | join(",")')
pods=$(kubectl -n "$NS" get pods -l "$sel" -o json 2>/dev/null)

running=$(echo "$pods" | jq '[.items[] | select(.metadata.deletionTimestamp == null and .status.phase == "Running")] | length')
[ "$running" -ge 3 ] || { echo "FAIL: only $running running pods of $DEP"; exit 1; }

bad=$(echo "$pods" | jq -r '
  .items[]
  | select(.metadata.deletionTimestamp == null and .status.phase == "Running")
  | select(any(.spec.containers[];
      (.resources.limits.cpu != "100m") or (.resources.limits.memory != "128Mi")
      or (.resources.requests.cpu != "50m") or (.resources.requests.memory != "64Mi")))
  | .metadata.name')
[ -z "$bad" ] || { echo "FAIL: pods without the LimitRange defaults (limits 100m/128Mi, requests 50m/64Mi): $(echo $bad)"; exit 1; }

echo "OK: Deployment $DEP runs 3/3 ready pods with the namespace default resources"
exit 0
