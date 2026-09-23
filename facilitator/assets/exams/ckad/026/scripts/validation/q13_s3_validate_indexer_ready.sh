#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=helmyard
DEP=stop-indexer

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
img=$(echo "$json" | jq -r '.spec.template.spec.containers[0].image')
lane=$(echo "$json" | jq -r '.spec.template.metadata.labels.lane // empty')
read -r gen obs spec upd ready <<<"$(echo "$json" | jq -r '[.metadata.generation, (.status.observedGeneration // 0), (.spec.replicas // 0), (.status.updatedReplicas // 0), (.status.readyReplicas // 0)] | map(tostring) | join(" ")')"

[ "$img" = "nginx:1.26" ] || { echo "ERR: $DEP runs image '$img', expected nginx:1.26"; exit 1; }
[ "$lane" = "local" ] || { echo "ERR: $DEP Pods lost the label lane=local"; exit 1; }
[ "$spec" = "3" ] || { echo "ERR: $DEP has $spec replicas, expected 3"; exit 1; }
if [ "$obs" != "$gen" ] || [ "$upd" != "3" ] || [ "$ready" != "3" ]; then
  echo "ERR: $DEP not fully rolled out (updated=$upd ready=$ready of 3)"
  exit 1
fi

echo "OK: $DEP has 3/3 ready replicas on nginx:1.26"
exit 0
