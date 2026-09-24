#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=routes; DEP=prod-route-board
O=/home/candidate/exam/q16/overlays/prod

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in $NS"; exit 1; }

env_ref=$(echo "$json" | jq -r '[.spec.template.spec.containers[] | select(.name=="web") | .envFrom[]? | .configMapRef.name // empty][0] // empty')
vol_ref=$(echo "$json" | jq -r '[.spec.template.spec.volumes[]? | select(.name=="settings") | .configMap.name // empty][0] // empty')
echo "$env_ref" | grep -Eq '^prod-route-settings-[a-z0-9]{5,}$' || { echo "FAIL: web must load a generated ConfigMap prod-route-settings-<hash> (got '$env_ref')"; exit 1; }
[ "$vol_ref" = "$env_ref" ] || { echo "FAIL: the settings volume and envFrom must reference the same generated ConfigMap ($vol_ref vs $env_ref)"; exit 1; }

data=$(kubectl -n "$NS" get configmap "$env_ref" -o json 2>/dev/null | jq -c '.data // {} | to_entries | sort_by(.key) | from_entries') || { echo "FAIL: ConfigMap $env_ref does not exist in $NS"; exit 1; }
[ -n "$data" ] || { echo "FAIL: ConfigMap $env_ref does not exist in $NS"; exit 1; }
want='{"FEED_URL":"http://feed.routes.internal/v2","MAX_STOPS":"40","NIGHT_SERVICE":"enabled","ROUTE_MODE":"express"}'
[ "$data" = "$want" ] || { echo "FAIL: $env_ref must hold the base keys merged with the prod literals; got $data"; exit 1; }

K=""
for f in kustomization.yaml kustomization.yml Kustomization; do [ -f "$O/$f" ] && { K="$O/$f"; break; }; done
[ -n "$K" ] && grep -Eq 'behavior:[[:space:]]*["'"'"']?merge' "$K" || { echo "FAIL: the prod overlay must merge into the base generator (behavior: merge)"; exit 1; }

rendered=$(kubectl kustomize "$O" 2>/dev/null | kubectl create --dry-run=client -o json -f - 2>/dev/null \
  | jq -r 'if .kind=="List" then .items[] else . end | select(.kind=="ConfigMap") | .metadata.name')
echo "$rendered" | grep -qx "$env_ref" || { echo "FAIL: live ConfigMap $env_ref is not what overlays/prod renders now ($(echo $rendered)); re-apply the overlay"; exit 1; }

echo "PASS: $DEP uses $env_ref with the merged data"
exit 0
