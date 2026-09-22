#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
json=$(kubectl -n manifest get service manifest-api -o json 2>/dev/null)
[ -z "$json" ] && { echo "FAIL: service manifest-api not found"; exit 1; }
stype=$(echo "$json" | jq -r '.spec.type')
tp=$(echo "$json" | jq -r '[.spec.ports[] | select(.port == 8080) | .targetPort | tostring] | first // empty')
[ "$stype" = "ClusterIP" ] || { echo "FAIL: service type changed to '$stype' (must stay ClusterIP)"; exit 1; }
[ -n "$tp" ] || { echo "FAIL: service manifest-api no longer exposes port 8080"; exit 1; }
if [ "$tp" = "80" ] || [ "$tp" = "http" ]; then
  echo "OK: port 8080 -> targetPort $tp"
  exit 0
fi
echo "FAIL: port 8080 targets '$tp' (expected container port 80 / http)"
exit 1
