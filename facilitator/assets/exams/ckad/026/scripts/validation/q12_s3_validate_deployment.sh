#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=dispatch
DEP=dispatch-board
IMG=localhost:5000/dispatch-board:2.3

dep=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found in $NS"; exit 1; }
img=$(echo "$dep" | jq -r '.spec.template.spec.containers[] | select(.name=="board") | .image')
[ -n "$img" ] || { echo "ERR: $DEP has no container named board"; exit 1; }
[ "$img" = "$IMG" ] || { echo "ERR: container board runs '$img', expected $IMG"; exit 1; }

read -r spec ready updated avail < <(echo "$dep" | jq -r '"\(.spec.replicas) \(.status.readyReplicas // 0) \(.status.updatedReplicas // 0) \(.status.availableReplicas // 0)"')
[ "$spec" = "2" ] || { echo "ERR: $DEP has spec.replicas=$spec, expected 2"; exit 1; }
[ "$ready" = "2" ] && [ "$updated" = "2" ] && [ "$avail" = "2" ] \
  || { echo "ERR: $DEP ready=$ready updated=$updated available=$avail, expected 2/2/2"; exit 1; }

echo "OK: $DEP runs $IMG with 2 ready replicas"
exit 0
