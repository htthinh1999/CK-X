#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectro
LR=spectro-defaults

json=$(kubectl -n "$NS" get limitrange "$LR" -o json 2>/dev/null) || { echo "FAIL: LimitRange $LR not found in namespace $NS"; exit 1; }

echo "$json" | jq -e '
  [ .spec.limits[]?
    | select(.type == "Container")
    | select(.default.cpu == "100m" and .default.memory == "128Mi"
             and .defaultRequest.cpu == "50m" and .defaultRequest.memory == "64Mi") ]
  | length > 0' >/dev/null \
  || { echo "FAIL: LimitRange $LR needs a Container item with default cpu=100m/memory=128Mi and defaultRequest cpu=50m/memory=64Mi; got $(echo "$json" | jq -c '.spec.limits')"; exit 1; }

echo "OK: LimitRange $LR sets the expected container defaults"
exit 0
