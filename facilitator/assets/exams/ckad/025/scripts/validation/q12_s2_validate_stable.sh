#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=orbit; DEP=telemetry

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in $NS"; exit 1; }

img=$(echo "$json" | jq -r '[.spec.template.spec.containers[] | select(.name=="web") | .image][0] // empty')
read -r spec total updated ready <<<"$(echo "$json" | jq -r '[.spec.replicas, (.status.replicas // 0), (.status.updatedReplicas // 0), (.status.readyReplicas // 0)] | map(tostring) | join(" ")')"

if [ "$img" = "nginx:1.26" ] && [ "$spec" = "3" ] && [ "$total" = "3" ] && [ "$updated" = "3" ] && [ "$ready" = "3" ]; then
  echo "PASS: $DEP runs nginx:1.26 with 3/3 updated and Ready replicas"
  exit 0
fi
echo "FAIL: expected $DEP on nginx:1.26 with 3/3 ready (image=$img replicas=$spec total=$total updated=$updated ready=$ready)"
exit 1
