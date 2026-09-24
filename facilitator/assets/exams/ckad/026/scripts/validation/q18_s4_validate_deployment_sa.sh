#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=freight
DEP=freight-api
SA=freight-reader

dep=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found in $NS"; exit 1; }
tsa=$(echo "$dep" | jq -r '.spec.template.spec.serviceAccountName // .spec.template.spec.serviceAccount // "default"')
[ "$tsa" = "$SA" ] || { echo "ERR: $DEP pod template uses ServiceAccount '$tsa', expected $SA"; exit 1; }

# effective token automount: pod setting wins over the ServiceAccount setting
pam=$(echo "$dep" | jq -r '.spec.template.spec.automountServiceAccountToken | if . == null then "unset" else tostring end')
sam=$(kubectl -n "$NS" get serviceaccount "$SA" -o json 2>/dev/null | jq -r '.automountServiceAccountToken | if . == null then "unset" else tostring end')
if [ "$pam" = "false" ] || { [ "$pam" = "unset" ] && [ "$sam" = "false" ]; }; then
  echo "ERR: token automount is disabled (pod template: $pam, ServiceAccount: $sam)"; exit 1
fi

read -r spec ready updated avail < <(echo "$dep" | jq -r '"\(.spec.replicas) \(.status.readyReplicas // 0) \(.status.updatedReplicas // 0) \(.status.availableReplicas // 0)"')
[ "$ready" = "$spec" ] && [ "$updated" = "$spec" ] && [ "$avail" = "$spec" ] && [ "${spec:-0}" -ge 1 ] \
  || { echo "ERR: $DEP rollout not complete (spec=$spec ready=$ready updated=$updated available=$avail)"; exit 1; }

sel=$(echo "$dep" | jq -r '.spec.selector.matchLabels | to_entries | map("\(.key)=\(.value)") | join(",")')
live=$(kubectl -n "$NS" get pods -l "$sel" -o json 2>/dev/null | jq -c '[.items[] | select(.metadata.deletionTimestamp == null)]')
[ "$(echo "$live" | jq 'length')" -ge 1 ] || { echo "ERR: no running $DEP pods"; exit 1; }
bad=$(echo "$live" | jq -r --arg sa "$SA" '.[]
  | select( .spec.serviceAccountName != $sa
            or ([.spec.volumes[]? | select(any(.projected.sources[]?; has("serviceAccountToken")))] | length == 0)
            or ([.spec.containers[].volumeMounts[]? | select(.mountPath=="/var/run/secrets/kubernetes.io/serviceaccount")] | length == 0) )
  | .metadata.name')
[ -z "$bad" ] || { echo "ERR: pods without $SA identity or mounted API token: $(echo $bad)"; exit 1; }

echo "OK: $DEP pods run as $SA with the API token mounted"
exit 0
