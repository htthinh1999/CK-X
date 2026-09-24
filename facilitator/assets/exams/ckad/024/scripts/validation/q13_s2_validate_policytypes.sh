#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=pier
json=$(kubectl -n "$NS" get networkpolicy berth-db-access -o json 2>/dev/null) || { echo "FAIL: networkpolicy berth-db-access not found in $NS"; exit 1; }

pt=$(echo "$json" | jq -r '(.spec.policyTypes // []) | sort | join(",")')
[ "$pt" = "Ingress" ] || { echo "FAIL: policyTypes='$pt' (expected only Ingress)"; exit 1; }

echo "OK: policyTypes is [Ingress]"
exit 0
