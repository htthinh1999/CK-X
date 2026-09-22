#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl -n customs get pod declarations -o json 2>/dev/null) || { echo "ERR: pod declarations not found in customs"; exit 1; }
ro=$(echo "$p" | jq -r '
  [.spec.volumes[]? | select(.secret.secretName=="broker-creds") | .name] as $v
  | [.spec.containers[] | select(.name=="clerk") | .volumeMounts[]?
     | select((.name as $n | $v | index([$n])) and ((.mountPath | rtrimstr("/")) == "/etc/customs/creds"))
     | (.readOnly // false)] | first // "missing"')
[ "$ro" = "true" ] && { echo "OK: secret volume mount is readOnly"; exit 0; }
echo "ERR: readOnly on the /etc/customs/creds mount is '$ro' (want true)"; exit 1
