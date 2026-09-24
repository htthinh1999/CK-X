#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=almanac
P=almanac-reader

j=$(kubectl -n "$NS" get pod "$P" -o json 2>/dev/null) || { echo "ERR: pod $P not found"; exit 1; }
echo "$j" | jq -e 'any(.spec.containers[]; .image == "busybox:1.36" and any(.envFrom[]?; .configMapRef.name == "sky-settings"))' >/dev/null 2>&1 \
  && { echo "OK: $P loads sky-settings via envFrom"; exit 0; }
echo "ERR: $P has no busybox:1.36 container with envFrom.configMapRef sky-settings"
exit 1
