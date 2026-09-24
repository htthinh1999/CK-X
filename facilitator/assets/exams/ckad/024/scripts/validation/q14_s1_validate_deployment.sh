#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
json=$(kubectl -n gatehouse get deployment boom-gate -o json 2>/dev/null)
[ -z "$json" ] && { echo "FAIL: deployment boom-gate not found in namespace gatehouse"; exit 1; }
replicas=$(echo "$json" | jq -r '.spec.replicas // 0')
c=$(echo "$json" | jq -c '.spec.template.spec.containers[] | select(.name == "controller")')
[ "$replicas" = "3" ] || { echo "FAIL: replicas=$replicas (expected 3)"; exit 1; }
[ -n "$c" ] || { echo "FAIL: no container named 'controller'"; exit 1; }
img=$(echo "$c" | jq -r '.image')
cmd=$(echo "$c" | jq -r '((.command // []) + (.args // [])) | join(" ")')
[ "$img" = "busybox:1.36" ] || { echo "FAIL: controller image='$img' (expected busybox:1.36)"; exit 1; }
if echo "$cmd" | grep -q 'sleep 15' && echo "$cmd" | grep -q 'touch /tmp/gate-open'; then
  echo "OK: boom-gate has 3 replicas, container controller (busybox:1.36) creates /tmp/gate-open"
  exit 0
fi
echo "FAIL: controller command '$cmd' does not sleep 15 and touch /tmp/gate-open"
exit 1
