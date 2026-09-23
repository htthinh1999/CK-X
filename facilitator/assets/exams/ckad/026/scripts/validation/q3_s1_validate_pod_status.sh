#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=signals
POD=signal-box

pod=$(kubectl -n "$NS" get pod "$POD" -o json 2>/dev/null) || { echo "ERR: Pod $POD not found in $NS"; exit 1; }
echo "$pod" | jq -e '.metadata.deletionTimestamp == null' >/dev/null || { echo "ERR: Pod $POD is terminating"; exit 1; }

# main container: box / nginx:1.25 / cpu limit 250m
box=$(echo "$pod" | jq -c '.spec.containers[] | select(.name=="box")')
[ -n "$box" ] || { echo "ERR: Pod has no container named box"; exit 1; }
img=$(echo "$box" | jq -r '.image')
[[ "$img" == "nginx:1.25" || "$img" == "docker.io/library/nginx:1.25" ]] || { echo "ERR: container box image is $img, expected nginx:1.25"; exit 1; }
cpu=$(echo "$box" | jq -r '.resources.limits.cpu // empty')
[[ "$cpu" == "250m" || "$cpu" == "0.25" ]] || { echo "ERR: container box CPU limit is '${cpu:-none}', expected 250m"; exit 1; }

# init container: render / busybox:1.36, completed successfully
init=$(echo "$pod" | jq -c '(.spec.initContainers // [])[] | select(.name=="render")')
[ -n "$init" ] || { echo "ERR: Pod has no init container named render"; exit 1; }
iimg=$(echo "$init" | jq -r '.image')
[[ "$iimg" == "busybox:1.36" || "$iimg" == "docker.io/library/busybox:1.36" ]] || { echo "ERR: init container render image is $iimg, expected busybox:1.36"; exit 1; }
echo "$init" | jq -e '(.restartPolicy // "") != "Always"' >/dev/null || { echo "ERR: render must be a regular init container, not a sidecar"; exit 1; }
code=$(echo "$pod" | jq -r '(.status.initContainerStatuses // [])[] | select(.name=="render") | .state.terminated.exitCode // empty')
[ "$code" = "0" ] || { echo "ERR: init container render has not completed successfully (exitCode='${code:-none}')"; exit 1; }

echo "$pod" | jq -e '.status.phase=="Running" and ([(.status.containerStatuses // [])[] | select(.name=="box" and .ready==true)] | length == 1)' >/dev/null \
  || { echo "ERR: container box is not Running and Ready"; exit 1; }

echo "OK: $POD runs box (nginx:1.25, cpu limit 250m) after init container render completed"
exit 0
