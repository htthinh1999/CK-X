#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=permits; POD=permit-check

json=$(kubectl -n "$NS" get pod "$POD" -o json 2>/dev/null) || { echo "FAIL: Pod $POD not found in $NS"; exit 1; }
[ "$(echo "$json" | jq -r '.metadata.deletionTimestamp // empty')" = "" ] || { echo "FAIL: Pod $POD is terminating"; exit 1; }

img=$(echo "$json" | jq -r '[.spec.containers[].image] | join(",")')
[ "$img" = "registry.k8s.io/pause:3.9" ] || { echo "FAIL: $POD must run registry.k8s.io/pause:3.9 (got $img)"; exit 1; }
sa=$(echo "$json" | jq -r '.spec.serviceAccountName // "default"')
[ "$sa" = "default" ] || { echo "FAIL: $POD must use ServiceAccount default (got $sa)"; exit 1; }

names=$(echo "$json" | jq -r '[.spec.imagePullSecrets[]?.name] | sort | join(",")')
if [ "$names" != "legacy-pull,permits-registry" ]; then
  echo "FAIL: $POD must receive both pull secrets of ServiceAccount default (legacy-pull,permits-registry); got '$names'"
  exit 1
fi
ready=$(echo "$json" | jq -r '[.status.conditions[]? | select(.type=="Ready") | .status][0] // empty')
[ "$ready" = "True" ] || { echo "FAIL: $POD is not Ready"; exit 1; }
echo "PASS: $POD was re-created and carries both pull secrets from the ServiceAccount"
exit 0
