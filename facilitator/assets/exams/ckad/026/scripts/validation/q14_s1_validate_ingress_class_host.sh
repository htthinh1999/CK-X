#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=platform
ING=platform-board
HOST=board.transit.local

ing=$(kubectl -n "$NS" get ingress "$ING" -o json 2>/dev/null) || { echo "ERR: Ingress $ING not found in $NS"; exit 1; }
cls=$(echo "$ing" | jq -r '.spec.ingressClassName // empty')
[ "$cls" = "traefik" ] || { echo "ERR: spec.ingressClassName is '${cls:-unset}', expected traefik"; exit 1; }
echo "$ing" | jq -e --arg h "$HOST" '[.spec.rules[]? | select(.host==$h)] | length > 0' >/dev/null \
  || { echo "ERR: Ingress has no rule for host $HOST"; exit 1; }

echo "OK: $ING uses class traefik for host $HOST"
exit 0
