#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n winch get deployment hoist-controller -o json 2>/dev/null) || { echo "ERR: deployment hoist-controller not found in winch"; exit 1; }
names=$(echo "$j" | jq -r '[.spec.template.spec.containers[].name] | sort | join(",")')
[ "$names" = "hoist,log-tail" ] || { echo "ERR: containers are '$names' (want hoist and log-tail as regular containers)"; exit 1; }
img=$(echo "$j" | jq -r '.spec.template.spec.containers[] | select(.name=="log-tail") | .image')
[ "$img" = "busybox:1.36" ] && { echo "OK: two containers hoist + log-tail (busybox:1.36)"; exit 0; }
echo "ERR: log-tail image is '$img' (want busybox:1.36)"; exit 1
