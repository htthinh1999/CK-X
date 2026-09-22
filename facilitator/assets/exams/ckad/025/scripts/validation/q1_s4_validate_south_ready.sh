#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=starmap
D=orrery-south

j=$(kubectl -n "$NS" get deployment "$D" -o json 2>/dev/null) || { echo "ERR: deployment $D not found"; exit 1; }
img=$(echo "$j" | jq -r '.spec.template.spec.containers[0].image // empty')
ann=$(echo "$j" | jq -r '.spec.template.metadata.annotations.site // empty')
ready=$(echo "$j" | jq -r '.status.readyReplicas // 0')

[ "$img" = "nginx:1.25" ] || { echo "ERR: $D image is '$img', expected nginx:1.25"; exit 1; }
[ "$ann" = "south-ridge" ] || { echo "ERR: pod annotation site='$ann', expected south-ridge"; exit 1; }
[ "$ready" -eq 2 ] || { echo "ERR: $D readyReplicas=$ready, expected 2"; exit 1; }

echo "OK: $D has 2 ready replicas annotated site=south-ridge"
exit 0
