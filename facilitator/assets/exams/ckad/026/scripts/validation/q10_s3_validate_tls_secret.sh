#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=permits; SECRET=permits-tls
CRT_SHA=0810e5b45044d2c3723cf67370ad81dea4658162e327e3f37e7466f120be42e1
KEY_SHA=58660e33791d268035c660ef7a66148eaba1470c55def36c625616f823d01458

json=$(kubectl -n "$NS" get secret "$SECRET" -o json 2>/dev/null) || { echo "FAIL: Secret $SECRET not found in $NS"; exit 1; }
typ=$(echo "$json" | jq -r '.type')
[ "$typ" = "kubernetes.io/tls" ] || { echo "FAIL: $SECRET must be of type kubernetes.io/tls (got $typ)"; exit 1; }

crt=$(printf '%s' "$(echo "$json" | jq -r '.data["tls.crt"] // empty' | base64 -d 2>/dev/null)" | sha256sum | cut -d' ' -f1)
key=$(printf '%s' "$(echo "$json" | jq -r '.data["tls.key"] // empty' | base64 -d 2>/dev/null)" | sha256sum | cut -d' ' -f1)
[ "$crt" = "$CRT_SHA" ] || { echo "FAIL: tls.crt of $SECRET is not certs/gate.crt"; exit 1; }
[ "$key" = "$KEY_SHA" ] || { echo "FAIL: tls.key of $SECRET is not the private key that belongs to gate.crt"; exit 1; }
echo "PASS: $SECRET holds gate.crt and its matching private key"
exit 0
