#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n winch get deployment hoist-controller -o json 2>/dev/null) || { echo "ERR: deployment hoist-controller not found in winch"; exit 1; }
# app containers + native sidecars (init containers with restartPolicy Always)
c=$(echo "$j" | jq -c '.spec.template.spec | [.containers[], ((.initContainers // [])[] | select(.restartPolicy == "Always"))]')
names=$(echo "$c" | jq -r '[.[].name] | sort | join(",")')
[ "$names" = "hoist,log-tail" ] || { echo "ERR: containers are '$names' (want hoist and log-tail, as regular container or native sidecar)"; exit 1; }
img=$(echo "$c" | jq -r '.[] | select(.name=="log-tail") | .image')
[ "$img" = "busybox:1.36" ] && { echo "OK: two containers hoist + log-tail (busybox:1.36)"; exit 0; }
echo "ERR: log-tail image is '$img' (want busybox:1.36)"; exit 1
