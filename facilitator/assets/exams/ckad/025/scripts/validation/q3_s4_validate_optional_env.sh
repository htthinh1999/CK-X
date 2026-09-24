#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=vault; POD=cert-loader; SECRET=observatory-tls

json=$(kubectl -n "$NS" get pod "$POD" -o json 2>/dev/null) || { echo "FAIL: Pod $POD not found in $NS"; exit 1; }

ref=$(echo "$json" | jq -c '[.spec.containers[].env[]? | select(.name=="ROTATION_TOKEN") | .valueFrom.secretKeyRef][0] // empty')
[ -n "$ref" ] && [ "$ref" != "null" ] || { echo "FAIL: env ROTATION_TOKEN with a secretKeyRef not found"; exit 1; }

ok=$(echo "$ref" | jq -r --arg s "$SECRET" '(.name==$s) and (.key=="rotation.token") and (.optional==true)')
[ "$ok" = "true" ] || { echo "FAIL: ROTATION_TOKEN must reference $SECRET key rotation.token with optional: true (got $ref)"; exit 1; }

phase=$(echo "$json" | jq -r '.status.phase')
ready=$(echo "$json" | jq -r '[.status.conditions[]? | select(.type=="Ready") | .status][0] // empty')
[ "$phase" = "Running" ] && [ "$ready" = "True" ] || { echo "FAIL: Pod $POD is not Running/Ready (phase=$phase ready=$ready)"; exit 1; }

echo "PASS: ROTATION_TOKEN is an optional secretKeyRef and the Pod is Running"
exit 0
