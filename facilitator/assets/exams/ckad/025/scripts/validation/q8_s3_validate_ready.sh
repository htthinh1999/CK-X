#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=dome; DEP=skyview

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in $NS"; exit 1; }

read -r gen obs total updated ready <<<"$(echo "$json" | jq -r '[.metadata.generation, (.status.observedGeneration // 0), (.status.replicas // 0), (.status.updatedReplicas // 0), (.status.readyReplicas // 0)] | map(tostring) | join(" ")')"

if [ "$obs" = "$gen" ] && [ "$total" = "2" ] && [ "$updated" = "2" ] && [ "$ready" = "2" ]; then
  echo "PASS: 2/2 replicas updated and Ready"
  exit 0
fi
echo "FAIL: expected 2 updated and Ready replicas (replicas=$total updated=$updated ready=$ready observedGeneration=$obs/$gen)"
exit 1
