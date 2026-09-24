#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl -n customs get pod declarations -o json 2>/dev/null) || { echo "ERR: pod declarations not found in customs"; exit 1; }
ref=$(echo "$p" | jq -r '.spec.containers[] | select(.name=="clerk") | .env[]? | select(.name=="CUSTOMS_BROKER_ID") | "\(.valueFrom.secretKeyRef.name // "")/\(.valueFrom.secretKeyRef.key // "")"')
[ "$ref" = "broker-creds/broker-id" ] || { echo "ERR: CUSTOMS_BROKER_ID must come from secretKeyRef broker-creds/broker-id (got '${ref:-<none>}')"; exit 1; }
v=$(kubectl -n customs exec declarations -c clerk -- printenv CUSTOMS_BROKER_ID 2>/dev/null)
[ "$v" = "HL-0042" ] && { echo "OK: CUSTOMS_BROKER_ID=HL-0042 inside the container"; exit 0; }
echo "ERR: printenv CUSTOMS_BROKER_ID returned '${v:-<empty>}'"; exit 1
