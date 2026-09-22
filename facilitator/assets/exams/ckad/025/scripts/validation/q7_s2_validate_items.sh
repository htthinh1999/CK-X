#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=vault; POD=cert-loader; SECRET=observatory-tls

json=$(kubectl -n "$NS" get pod "$POD" -o json 2>/dev/null) || { echo "FAIL: Pod $POD not found in $NS"; exit 1; }

vol=$(echo "$json" | jq -r --arg s "$SECRET" '[.spec.volumes[]? | select(.secret.secretName==$s) | .name][0] // empty')
[ -n "$vol" ] || { echo "FAIL: Pod $POD has no Secret volume from $SECRET"; exit 1; }

items=$(echo "$json" | jq -c --arg v "$vol" '[.spec.volumes[] | select(.name==$v) | .secret.items[]? | {key, path}]')
if [ "$items" != '[{"key":"signing.key","path":"keys/private.pem"}]' ]; then
  echo "FAIL: volume $vol must project only key signing.key as path keys/private.pem (got $items)"
  exit 1
fi

mp=$(echo "$json" | jq -r --arg v "$vol" '[.spec.containers[].volumeMounts[]? | select(.name==$v) | .mountPath][0] // empty')
[ "${mp%/}" = "/etc/observatory" ] || { echo "FAIL: volume $vol must be mounted at /etc/observatory (got '$mp')"; exit 1; }

want=$(kubectl -n "$NS" get secret "$SECRET" -o jsonpath='{.data.signing\.key}' 2>/dev/null | base64 -d 2>/dev/null)
got=$(kubectl -n "$NS" exec "$POD" -- cat /etc/observatory/keys/private.pem 2>/dev/null)
if [ -z "$got" ] || [ "$got" != "$want" ]; then
  echo "FAIL: /etc/observatory/keys/private.pem in $POD does not contain the signing.key data"
  exit 1
fi

echo "PASS: only signing.key is mounted, as /etc/observatory/keys/private.pem"
exit 0
