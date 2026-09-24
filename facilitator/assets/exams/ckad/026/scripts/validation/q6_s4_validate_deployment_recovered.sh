#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=lostproperty; DEP=claims-desk

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found"; exit 1; }

base_uid=$(kubectl get namespace "$NS" -o jsonpath='{.metadata.annotations.transit\.example\.com/q8-desk-uid}' 2>/dev/null)
uid=$(echo "$json" | jq -r '.metadata.uid')
if [ -n "$base_uid" ] && [ "$uid" != "$base_uid" ]; then
  echo "FAIL: Deployment $DEP was deleted and re-created; it had to be left as it was"
  exit 1
fi
gen=$(echo "$json" | jq -r '.metadata.generation')
[ "$gen" = "1" ] || { echo "FAIL: Deployment $DEP was modified or restarted (generation $gen); only the ConfigMap should change"; exit 1; }

sel=$(echo "$json" | jq -r '.spec.selector.matchLabels | to_entries | map("\(.key)=\(.value)") | join(",")')
pods=$(kubectl -n "$NS" get pods -l "$sel" -o json)
nready=$(echo "$pods" | jq '[.items[] | select(.metadata.deletionTimestamp == null)
  | select(.status.phase=="Running")
  | select(any(.status.conditions[]?; .type=="Ready" and .status=="True"))
  | select(any(.status.conditions[]?; .type=="ContainersReady" and .status=="True"))] | length')
rdy=$(echo "$json" | jq -r '.status.readyReplicas // 0')
if [ "$rdy" != "2" ] || [ "$nready" -lt 2 ]; then
  echo "FAIL: $DEP must have 2 Ready Pods with both containers running (readyReplicas=$rdy, fully ready pods=$nready)"
  exit 1
fi
echo "PASS: $DEP is unchanged and both Pods run with all containers Ready"
exit 0
