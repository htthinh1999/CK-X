#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
vals=$(helm get values tugboat -n berth --all -o json 2>/dev/null)
[ -z "$vals" ] && { echo "FAIL: cannot read values of release tugboat"; exit 1; }
crew=$(echo "$vals" | jq -r '.podAnnotations.crew // empty')
owner=$(echo "$vals" | jq -r '.podAnnotations.owner // empty')
[ "$crew" = "night-shift" ] || { echo "FAIL: value podAnnotations.crew='$crew' (expected night-shift)"; exit 1; }
[ "$owner" = "berth-ops" ] || { echo "FAIL: existing value podAnnotations.owner was lost (got '$owner', expected berth-ops)"; exit 1; }

live=$(kubectl -n berth get deployment -l app.kubernetes.io/instance=tugboat -o json 2>/dev/null \
  | jq -r '.items[0].spec.template.metadata.annotations // {} | "\(.crew // "-") \(.owner // "-")"')
if [ "$live" = "night-shift berth-ops" ]; then
  echo "OK: tugboat pods annotated crew=night-shift and owner=berth-ops"
  exit 0
fi
echo "FAIL: tugboat pod template annotations crew/owner = '$live' (expected night-shift berth-ops)"
exit 1
