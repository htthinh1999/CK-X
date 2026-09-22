#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightwatch
SVC=watchtower-peers

json=$(kubectl -n "$NS" get service "$SVC" -o json 2>/dev/null) || { echo "FAIL: Service $SVC not found in namespace $NS"; exit 1; }

cip=$(echo "$json" | jq -r '.spec.clusterIP // empty')
[ "$cip" = "None" ] || { echo "FAIL: Service $SVC has clusterIP '$cip', expected None (headless)"; exit 1; }

sel=$(echo "$json" | jq -r '.spec.selector.app // empty')
[ "$sel" = "watchtower" ] || { echo "FAIL: Service selector app='$sel', expected app=watchtower"; exit 1; }

echo "$json" | jq -e '[.spec.ports[]? | select(.port == 80 and ((.targetPort // 80) | tostring) == "80")] | length > 0' >/dev/null \
  || { echo "FAIL: Service $SVC has no port 80 -> targetPort 80"; exit 1; }

n=$(kubectl -n "$NS" get endpoints "$SVC" -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null | wc -w)
[ "$n" -ge 2 ] || { echo "FAIL: Service $SVC has $n ready endpoint(s), expected 2"; exit 1; }

echo "OK: headless Service $SVC selects app=watchtower with $n endpoints"
exit 0
