#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
l=$(kubectl -n tides get configmap gauge-config -o json 2>/dev/null | jq -r '"\(.metadata.labels.tier // "")/\(.metadata.labels.region // "")"' 2>/dev/null)
[ "$l" = "gauge/west" ] && { echo "OK: gauge-config labelled tier=gauge region=west"; exit 0; }
echo "ERR: gauge-config labels tier/region = '${l:-<missing>}' (want gauge/west)"; exit 1
