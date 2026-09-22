#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=lighthouse
json=$(kubectl -n "$NS" get configmap lamp-config -o json 2>/dev/null) || { echo "FAIL: configmap lamp-config not found in $NS"; exit 1; }

rot=$(echo "$json" | jq -r '.data.rotation // empty')
col=$(echo "$json" | jq -r '.data.color // empty')
[ "$rot" = "fast" ] || { echo "FAIL: lamp-config rotation='$rot' (expected fast)"; exit 1; }
[ "$col" = "white" ] || { echo "FAIL: lamp-config color='$col' (expected unchanged value white)"; exit 1; }

echo "OK: lamp-config has rotation=fast and color=white"
exit 0
