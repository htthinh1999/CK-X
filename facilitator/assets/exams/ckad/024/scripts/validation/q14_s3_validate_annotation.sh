#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=lighthouse
json=$(kubectl -n "$NS" get configmap lamp-config -o json 2>/dev/null) || { echo "FAIL: configmap lamp-config not found in $NS"; exit 1; }

val=$(echo "$json" | jq -r '.metadata.annotations["harbor-logistics.io/change-ticket"] // empty')
[ "$val" = "HL-4471" ] || { echo "FAIL: annotation harbor-logistics.io/change-ticket='$val' (expected HL-4471)"; exit 1; }

echo "OK: lamp-config is annotated harbor-logistics.io/change-ticket=HL-4471"
exit 0
