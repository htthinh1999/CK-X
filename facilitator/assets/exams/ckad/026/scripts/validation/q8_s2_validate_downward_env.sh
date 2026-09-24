#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=signals
POD=signal-box

pod=$(kubectl -n "$NS" get pod "$POD" -o json 2>/dev/null) || { echo "ERR: Pod $POD not found in $NS"; exit 1; }
env=$(echo "$pod" | jq -c '[(.spec.initContainers // [])[] | select(.name=="render") | (.env // [])[]]')
[ "$env" != "[]" ] || { echo "ERR: init container render has no environment variables"; exit 1; }

echo "$env" | jq -e 'any(.[]; .valueFrom.fieldRef.fieldPath == "metadata.name")' >/dev/null \
  || { echo "ERR: render has no env var from fieldRef metadata.name (Pod name)"; exit 1; }
echo "$env" | jq -e 'any(.[]; .valueFrom.fieldRef.fieldPath == "spec.nodeName")' >/dev/null \
  || { echo "ERR: render has no env var from fieldRef spec.nodeName (node name)"; exit 1; }

rf=$(echo "$env" | jq -c '[.[] | .valueFrom.resourceFieldRef // empty | select(.resource == "limits.cpu")]')
[ "$rf" != "[]" ] || { echo "ERR: render has no env var from resourceFieldRef limits.cpu"; exit 1; }
echo "$rf" | jq -e 'any(.[]; .containerName == "box")' >/dev/null \
  || { echo "ERR: the limits.cpu resourceFieldRef must reference containerName box (default is the init container itself)"; exit 1; }
echo "$rf" | jq -e 'any(.[]; .containerName == "box" and ((.divisor // "1") | tostring | IN("1m", "0.001")))' >/dev/null \
  || { echo "ERR: the limits.cpu resourceFieldRef for box must use divisor 1m to expose millicores"; exit 1; }

echo "OK: render gets Pod name, node name and box CPU limit (millicores) from the downward API"
exit 0
