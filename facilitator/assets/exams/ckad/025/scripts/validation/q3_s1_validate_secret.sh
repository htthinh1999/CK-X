#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=vault; SECRET=observatory-tls; D=/home/candidate/exam/q3

json=$(kubectl -n "$NS" get secret "$SECRET" -o json 2>/dev/null) || { echo "FAIL: Secret $SECRET not found in $NS"; exit 1; }

for k in signing.key ca.crt; do
  want=$(cat "$D/$k" 2>/dev/null)
  got=$(echo "$json" | jq -r --arg k "$k" '.data[$k] // empty' | base64 -d 2>/dev/null)
  if [ -z "$got" ] || [ "$got" != "$want" ]; then
    echo "FAIL: key $k is missing from $SECRET or does not match $D/$k"
    exit 1
  fi
done

echo "PASS: Secret $SECRET holds signing.key and ca.crt with the file contents"
exit 0
