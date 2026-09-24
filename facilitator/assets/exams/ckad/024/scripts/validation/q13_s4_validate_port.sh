#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=pier
json=$(kubectl -n "$NS" get networkpolicy berth-db-access -o json 2>/dev/null) || { echo "FAIL: networkpolicy berth-db-access not found in $NS"; exit 1; }

nrules=$(echo "$json" | jq '(.spec.ingress // []) | length')
[ "$nrules" = "1" ] || { echo "FAIL: expected exactly 1 ingress rule, found $nrules"; exit 1; }
nports=$(echo "$json" | jq '(.spec.ingress[0].ports // []) | length')
[ "$nports" = "1" ] || { echo "FAIL: expected exactly 1 port in the ingress rule, found $nports"; exit 1; }

port=$(echo "$json" | jq -r '.spec.ingress[0].ports[0].port // empty | tostring')
proto=$(echo "$json" | jq -r '.spec.ingress[0].ports[0].protocol // "TCP"')
endport=$(echo "$json" | jq -r '.spec.ingress[0].ports[0].endPort // empty')

[ "$port" = "6379" ] || { echo "FAIL: ingress port='$port' (expected 6379)"; exit 1; }
[ "$proto" = "TCP" ] || { echo "FAIL: ingress protocol='$proto' (expected TCP)"; exit 1; }
[ -z "$endport" ] || { echo "FAIL: ingress port has endPort $endport (expected the single port 6379)"; exit 1; }

echo "OK: ingress is limited to TCP port 6379"
exit 0
