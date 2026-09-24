#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=dome; DEP=skyview

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in $NS"; exit 1; }

# generation 1 would mean the Deployment was deleted and recreated instead of fixed in place
gen=$(echo "$json" | jq -r '.metadata.generation // 0')
[ "$gen" -ge 2 ] 2>/dev/null || { echo "FAIL: Deployment $DEP looks recreated/unmodified (generation=$gen)"; exit 1; }

ok=$(echo "$json" | jq -r '
  .spec.replicas == 2 and
  ([.spec.template.spec.containers[] | select(.name=="web")][0] as $c |
    $c.image == "nginx:1.25" and
    $c.readinessProbe.initialDelaySeconds == 3 and
    $c.readinessProbe.periodSeconds == 5 and
    $c.readinessProbe.failureThreshold == 2 and
    ($c.livenessProbe.tcpSocket.port | tostring) == "80" and
    $c.livenessProbe.initialDelaySeconds == 10 and
    $c.livenessProbe.periodSeconds == 15)
' 2>/dev/null)
[ "$ok" = "true" ] || { echo "FAIL: other settings changed (replicas 2, image nginx:1.25, readiness 3/5/2, liveness tcp 80 10/15 expected)"; exit 1; }

echo "PASS: replicas, image, probe timings and liveness probe unchanged"
exit 0
