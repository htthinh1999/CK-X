#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl -n customs get pod declarations -o json 2>/dev/null) || { echo "ERR: pod declarations not found in customs"; exit 1; }
# a volume that projects the WHOLE secret (no items list)
vol=$(echo "$p" | jq -r '[.spec.volumes[]? | select(.secret.secretName=="broker-creds" and (((.secret.items // []) | length) == 0)) | .name] | first // empty')
[ -n "$vol" ] || { echo "ERR: no volume mounting the whole secret broker-creds (without items)"; exit 1; }
m=$(echo "$p" | jq -r --arg v "$vol" '[.spec.containers[] | select(.name=="clerk") | .volumeMounts[]? | select(.name==$v and ((.mountPath | rtrimstr("/")) == "/etc/customs/creds") and ((.subPath // "") == ""))] | length')
[ "${m:-0}" -ge 1 ] || { echo "ERR: container clerk does not mount volume '$vol' at /etc/customs/creds"; exit 1; }
t=$(kubectl -n customs exec declarations -c clerk -- cat /etc/customs/creds/api-token 2>/dev/null)
b=$(kubectl -n customs exec declarations -c clerk -- cat /etc/customs/creds/broker-id 2>/dev/null)
[ "$t" = "tk-7731-harbor" ] && [ "$b" = "HL-0042" ] && { echo "OK: both secret keys are files under /etc/customs/creds"; exit 0; }
echo "ERR: could not read both keys from /etc/customs/creds in the running pod"; exit 1
