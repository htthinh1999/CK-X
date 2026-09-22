#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=starmap
D=orrery-north

j=$(kubectl -n "$NS" get deployment "$D" -o json 2>/dev/null) || { echo "ERR: deployment $D not found"; exit 1; }
img=$(echo "$j" | jq -r '.spec.template.spec.containers[0].image // empty')
ready=$(echo "$j" | jq -r '.status.readyReplicas // 0')
upd=$(echo "$j" | jq -r '.status.updatedReplicas // 0')
total=$(echo "$j" | jq -r '.status.replicas // 0')

[ "$img" = "nginx:1.25" ] || { echo "ERR: $D image is '$img', expected nginx:1.25"; exit 1; }
[ "$ready" -eq 2 ] && [ "$upd" -eq 2 ] && [ "$total" -eq 2 ] || { echo "ERR: $D ready=$ready updated=$upd total=$total, expected 2/2/2"; exit 1; }

echo "OK: $D runs nginx:1.25 with 2 ready replicas"
exit 0
