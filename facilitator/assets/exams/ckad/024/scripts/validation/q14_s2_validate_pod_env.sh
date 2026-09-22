#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=lighthouse
dj=$(kubectl -n "$NS" get deployment lamp-driver -o json 2>/dev/null) || { echo "FAIL: deployment lamp-driver not found in $NS"; exit 1; }

# The value must still come from the ConfigMap key (not hard-coded)
ref=$(echo "$dj" | jq -r '[.spec.template.spec.containers[].env[]? | select(.name == "LAMP_ROTATION")][0] | "\(.valueFrom.configMapKeyRef.name // "")/\(.valueFrom.configMapKeyRef.key // "")"' 2>/dev/null)
[ "$ref" = "lamp-config/rotation" ] || { echo "FAIL: LAMP_ROTATION is not read from configmap lamp-config key rotation (got '$ref')"; exit 1; }

want=$(echo "$dj" | jq -r '.spec.replicas // 1')
ready=$(echo "$dj" | jq -r '.status.readyReplicas // 0')
updated=$(echo "$dj" | jq -r '.status.updatedReplicas // 0')
[ "$want" = "2" ] || { echo "FAIL: lamp-driver has $want replicas (expected 2)"; exit 1; }
[ "$ready" = "2" ] && [ "$updated" = "2" ] || { echo "FAIL: lamp-driver ready=$ready updated=$updated (expected 2/2)"; exit 1; }

pods=$(kubectl -n "$NS" get pods -l app=lamp-driver -o json 2>/dev/null \
  | jq -r '.items[] | select(.metadata.deletionTimestamp == null and .status.phase == "Running") | .metadata.name')
n=0
for p in $pods; do
  v=$(kubectl -n "$NS" exec "$p" -- printenv LAMP_ROTATION 2>/dev/null | tr -d '[:space:]')
  [ "$v" = "fast" ] || { echo "FAIL: pod $p has LAMP_ROTATION='$v' (expected fast)"; exit 1; }
  n=$((n + 1))
done
[ "$n" -ge 2 ] || { echo "FAIL: only $n running lamp-driver pod(s) found (expected 2)"; exit 1; }

echo "OK: all $n running lamp-driver pods see LAMP_ROTATION=fast from the ConfigMap"
exit 0
