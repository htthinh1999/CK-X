#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=vault; POD=cert-loader; SECRET=observatory-tls

json=$(kubectl -n "$NS" get pod "$POD" -o json 2>/dev/null) || { echo "FAIL: Pod $POD not found in $NS"; exit 1; }

mode=$(echo "$json" | jq -r --arg s "$SECRET" '[.spec.volumes[]? | select(.secret.secretName==$s) | .secret.defaultMode][0] // empty')
[ "$mode" = "256" ] || { echo "FAIL: defaultMode of the $SECRET volume must be 0400 (256), got '$mode'"; exit 1; }

perm=$(kubectl -n "$NS" exec "$POD" -- stat -L -c %a /etc/observatory/keys/private.pem 2>/dev/null | tr -d '[:space:]')
[ "$perm" = "400" ] || { echo "FAIL: /etc/observatory/keys/private.pem has mode '$perm', expected 400"; exit 1; }

echo "PASS: defaultMode is 0400 and the key file is mode 400"
exit 0
