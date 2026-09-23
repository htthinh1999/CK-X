#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=helmyard
DEP=route-planner

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
img=$(echo "$json" | jq -r '.spec.template.spec.containers[0].image')
zone=$(echo "$json" | jq -r '.spec.template.metadata.annotations["transit.example/zone"] // empty')
lane=$(echo "$json" | jq -r '.spec.template.metadata.labels.lane // empty')
mem=$(echo "$json" | jq -r '.spec.template.spec.containers[0].resources.limits.memory // empty')
read -r gen obs spec upd ready <<<"$(echo "$json" | jq -r '[.metadata.generation, (.status.observedGeneration // 0), (.spec.replicas // 0), (.status.updatedReplicas // 0), (.status.readyReplicas // 0)] | map(tostring) | join(" ")')"

[ "$img" = "nginx:1.26" ] || { echo "ERR: $DEP runs '$img'; the 0.2.0 default image is nginx:1.26"; exit 1; }
[ "$zone" = "north-yard" ] && [ "$lane" = "express" ] && [ "$mem" = "64Mi" ] || { echo "ERR: $DEP lost custom annotation/label/memory limit (zone=$zone lane=$lane memory=$mem)"; exit 1; }
[ "$spec" = "2" ] || { echo "ERR: $DEP has $spec replicas, expected 2"; exit 1; }
if [ "$obs" != "$gen" ] || [ "$upd" != "2" ] || [ "$ready" != "2" ]; then
  echo "ERR: $DEP not fully rolled out (updated=$upd ready=$ready of 2)"
  exit 1
fi

refresh=$(kubectl -n "$NS" get configmap "${DEP}-board" -o jsonpath='{.data.refreshSeconds}' 2>/dev/null)
[ "$refresh" = "30" ] || { echo "ERR: ConfigMap ${DEP}-board missing or refreshSeconds is '$refresh' (0.2.0 default is 30)"; exit 1; }

echo "OK: $DEP 2/2 ready on nginx:1.26 with its custom values, board ConfigMap present"
exit 0
