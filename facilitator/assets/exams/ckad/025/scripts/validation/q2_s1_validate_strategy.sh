#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=mirror
D=reflector

j=$(kubectl -n "$NS" get deployment "$D" -o json 2>/dev/null) || { echo "ERR: deployment $D not found"; exit 1; }
t=$(echo "$j" | jq -r '.spec.strategy.type // empty')
ms=$(echo "$j" | jq -r '.spec.strategy.rollingUpdate.maxSurge // empty | tostring')
mu=$(echo "$j" | jq -r '.spec.strategy.rollingUpdate.maxUnavailable // empty | tostring')

[ "$t" = "RollingUpdate" ] || { echo "ERR: strategy type is '$t', expected RollingUpdate"; exit 1; }
[ "$ms" = "1" ] || { echo "ERR: maxSurge is '$ms', expected 1"; exit 1; }
[ "$mu" = "0" ] || [ "$mu" = "0%" ] || { echo "ERR: maxUnavailable is '$mu', expected 0"; exit 1; }

echo "OK: RollingUpdate maxSurge=$ms maxUnavailable=$mu"
exit 0
