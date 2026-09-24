#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=antenna; SVC=dish-receiver; DEP=dish-receiver

svc=$(kubectl -n "$NS" get service "$SVC" -o json 2>/dev/null) || { echo "FAIL: Service $SVC not found in $NS"; exit 1; }

# The Deployment must be untouched: its container port is still named rx-http (80)
dport=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null | jq -r '[.spec.template.spec.containers[].ports[]? | select(.name=="rx-http") | .containerPort][0] // empty')
[ "$dport" = "80" ] || { echo "FAIL: Deployment $DEP must still declare container port rx-http=80 (do not modify the Deployment)"; exit 1; }

tp=$(echo "$svc" | jq -r '[.spec.ports[]? | select(.port==8080) | .targetPort][0] // empty | tostring')
[ "$tp" = "rx-http" ] || { echo "FAIL: Service port 8080 must use targetPort rx-http (by name), got '$tp'"; exit 1; }

sel=$(echo "$svc" | jq -c '.spec.selector')
[ "$sel" = '{"app":"dish-receiver"}' ] || { echo "FAIL: Service selector must stay app=dish-receiver (got $sel)"; exit 1; }

echo "PASS: port 8080 targets the named container port rx-http"
exit 0
