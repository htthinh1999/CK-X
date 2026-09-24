#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n customs get secret broker-creds -o json 2>/dev/null) || { echo "ERR: secret broker-creds not found in customs"; exit 1; }
type=$(echo "$j" | jq -r '.type')
tok=$(echo "$j" | jq -r '.data["api-token"] // ""' | base64 -d 2>/dev/null)
bid=$(echo "$j" | jq -r '.data["broker-id"] // ""' | base64 -d 2>/dev/null)
[ "$type" = "Opaque" ] || { echo "ERR: secret type is '$type' (want Opaque / generic)"; exit 1; }
[ "$tok" = "tk-7731-harbor" ] && [ "$bid" = "HL-0042" ] && { echo "OK: broker-creds holds api-token and broker-id"; exit 0; }
echo "ERR: api-token='$tok' broker-id='$bid'"; exit 1
