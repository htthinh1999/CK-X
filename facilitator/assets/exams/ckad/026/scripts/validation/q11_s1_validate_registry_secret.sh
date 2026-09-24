#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=permits; SECRET=permits-registry
SERVER="registry.permits.transit.local:5443"; USER_="permit-bot"; PASS_='Gr33n$ignal-7'

json=$(kubectl -n "$NS" get secret "$SECRET" -o json 2>/dev/null) || { echo "FAIL: Secret $SECRET not found in $NS"; exit 1; }
typ=$(echo "$json" | jq -r '.type')
[ "$typ" = "kubernetes.io/dockerconfigjson" ] || { echo "FAIL: $SECRET must be of type kubernetes.io/dockerconfigjson (got $typ)"; exit 1; }

cfg=$(echo "$json" | jq -r '.data[".dockerconfigjson"] // empty' | base64 -d 2>/dev/null)
echo "$cfg" | jq -e . >/dev/null 2>&1 || { echo "FAIL: .dockerconfigjson of $SECRET is not valid JSON"; exit 1; }

servers=$(echo "$cfg" | jq -r '.auths // {} | keys | join(",")')
[ "$servers" = "$SERVER" ] || { echo "FAIL: $SECRET must hold credentials for exactly $SERVER (got '$servers')"; exit 1; }

u=$(echo "$cfg" | jq -r --arg s "$SERVER" '.auths[$s].username // empty')
p=$(echo "$cfg" | jq -r --arg s "$SERVER" '.auths[$s].password // empty')
a=$(echo "$cfg" | jq -r --arg s "$SERVER" '.auths[$s].auth // empty')
[ "$u" = "$USER_" ] || { echo "FAIL: username for $SERVER must be $USER_ (got '$u')"; exit 1; }
[ "$p" = "$PASS_" ] || { echo "FAIL: password for $SERVER is not the one given in the task (check shell quoting)"; exit 1; }
if [ -n "$a" ] && [ "$(echo "$a" | base64 -d 2>/dev/null)" != "$USER_:$PASS_" ]; then
  echo "FAIL: the auth field for $SERVER does not match username:password"
  exit 1
fi
echo "PASS: $SECRET holds the credentials for $SERVER"
exit 0
