#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=fares; DEP=fare-board; C=board

cm=$(kubectl -n "$NS" get configmap fare-table -o json --show-managed-fields 2>/dev/null) || { echo "ERR: ConfigMap fare-table not found"; exit 1; }
want=$(echo "$cm" | jq -r '.data["peak.txt"] // empty')
echo "$want" | grep -q 'PEAK 3.95' || { echo "ERR: fare-table peak.txt has not been changed to PEAK 3.95 yet"; exit 1; }
updated=$(echo "$cm" | jq -r '[.metadata.managedFields[]?.time // empty] + [.metadata.creationTimestamp] | max')

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
read -r gen obs spec upd ready <<<"$(echo "$json" | jq -r '[.metadata.generation, (.status.observedGeneration // 0), (.spec.replicas // 0), (.status.updatedReplicas // 0), (.status.readyReplicas // 0)] | map(tostring) | join(" ")')"
if [ "$obs" != "$gen" ] || [ "$upd" != "$spec" ] || [ "$ready" != "$spec" ] || [ "${spec:-0}" -lt 1 ]; then
  echo "ERR: $DEP is not fully rolled out and Ready (updated=$upd ready=$ready of $spec)"
  exit 1
fi

pods=$(kubectl -n "$NS" get pods -l app=fare-board -o json 2>/dev/null | jq -r '.items[] | select(.metadata.deletionTimestamp == null) | "\(.metadata.name) \(.metadata.creationTimestamp)"')
[ -n "$pods" ] || { echo "ERR: no Pods of $DEP"; exit 1; }
while read -r pod created; do
  if [[ ! "$created" < "$updated" ]]; then
    echo "ERR: Pod $pod was created ($created) after the ConfigMap change ($updated); running Pods must pick up the change without being re-created"
    exit 1
  fi
  got=$(timeout 15 kubectl -n "$NS" exec "$pod" -c "$C" -- cat /usr/share/nginx/html/fares/current.txt 2>/dev/null)
  if [ "$got" != "$(printf '%s' "$want")" ]; then
    echo "ERR: $pod still serves '$got' in current.txt (ConfigMap has '$(printf '%s' "$want")'); give the kubelet up to ~2 minutes, and do not use subPath"
    exit 1
  fi
done <<< "$pods"

echo "OK: Pods created before the ConfigMap change now serve the new peak fare"
exit 0
