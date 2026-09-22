#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=wharf
json=$(kubectl -n "$NS" get resourcequota wharf-quota -o json 2>/dev/null) || { echo "FAIL: resourcequota wharf-quota not found in $NS"; exit 1; }

pods=$(echo "$json" | jq -r '.spec.hard.pods // empty')
cpu=$(echo "$json" | jq -r '.spec.hard["requests.cpu"] // empty')
mem=$(echo "$json" | jq -r '.spec.hard["limits.memory"] // empty')

[ "$pods" = "4" ] || { echo "FAIL: wharf-quota pods='$pods' (expected 4)"; exit 1; }
[ "$cpu" = "400m" ] || { echo "FAIL: wharf-quota requests.cpu='$cpu' (expected 400m)"; exit 1; }
[ "$mem" = "512Mi" ] || { echo "FAIL: wharf-quota limits.memory='$mem' (expected 512Mi)"; exit 1; }

echo "OK: wharf-quota hard pods=4, requests.cpu=400m, limits.memory=512Mi"
exit 0
