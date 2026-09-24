#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=signal
json=$(kubectl -n "$NS" get pod foghorn -o json 2>/dev/null) || { echo "FAIL: pod foghorn not found in $NS"; exit 1; }

img=$(echo "$json" | jq -r '.spec.containers[0].image // empty')
app=$(echo "$json" | jq -r '.metadata.labels.app // empty')
phase=$(echo "$json" | jq -r '.status.phase // empty')

case "$img" in
  nginx:1.25|docker.io/library/nginx:1.25) ;;
  *) echo "FAIL: pod foghorn image is '$img' (expected nginx:1.25)"; exit 1 ;;
esac
[ "$app" = "foghorn" ] || { echo "FAIL: pod foghorn label app='$app' (expected foghorn)"; exit 1; }
[ "$phase" = "Running" ] || { echo "FAIL: pod foghorn phase is '$phase' (expected Running)"; exit 1; }

echo "OK: pod foghorn runs nginx:1.25 with label app=foghorn"
exit 0
