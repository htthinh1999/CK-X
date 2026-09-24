#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=wharf
json=$(kubectl -n "$NS" get pod forklift -o json 2>/dev/null) || { echo "FAIL: pod forklift not found in $NS"; exit 1; }

img=$(echo "$json" | jq -r '.spec.containers[0].image // empty')
case "$img" in
  nginx:1.25|docker.io/library/nginx:1.25) ;;
  *) echo "FAIL: forklift image is '$img' (expected nginx:1.25)"; exit 1 ;;
esac

phase=$(echo "$json" | jq -r '.status.phase // empty')
[ "$phase" = "Running" ] || { echo "FAIL: forklift phase='$phase' (expected Running)"; exit 1; }

res=$(echo "$json" | jq -c '.spec.containers[0].resources // {}')
rc=$(echo "$res" | jq -r '.requests.cpu // empty')
rmem=$(echo "$res" | jq -r '.requests.memory // empty')
lc=$(echo "$res" | jq -r '.limits.cpu // empty')
lm=$(echo "$res" | jq -r '.limits.memory // empty')

[ "$rc" = "50m" ] && [ "$rmem" = "64Mi" ] || { echo "FAIL: forklift requests cpu=$rc memory=$rmem (expected 50m / 64Mi)"; exit 1; }
[ "$lc" = "100m" ] && [ "$lm" = "128Mi" ] || { echo "FAIL: forklift limits cpu=$lc memory=$lm (expected 100m / 128Mi)"; exit 1; }

echo "OK: forklift is Running with requests 50m/64Mi and limits 100m/128Mi"
exit 0
