#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=dome; DEP=skyview

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in $NS"; exit 1; }

probe=$(echo "$json" | jq -c '[.spec.template.spec.containers[] | select(.name=="web") | .readinessProbe][0] // empty')
[ -n "$probe" ] && [ "$probe" != "null" ] || { echo "FAIL: container web has no readinessProbe"; exit 1; }

path=$(echo "$probe" | jq -r '.httpGet.path // empty')
port=$(echo "$probe" | jq -r '.httpGet.port // empty | tostring')
if [ "$path" != "/" ] || { [ "$port" != "80" ] && [ "$port" != "http" ]; }; then
  echo "FAIL: readinessProbe must be httpGet path / port 80 (got path='$path' port='$port')"
  exit 1
fi

echo "PASS: readinessProbe is httpGet / on port 80"
exit 0
