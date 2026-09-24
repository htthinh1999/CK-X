#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=sleepers; DEP=sleeper-berths; C=warmer

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
sp=$(echo "$json" | jq -c --arg c "$C" '[.spec.template.spec.containers[] | select(.name==$c)][0].startupProbe // empty')
if [ -z "$sp" ]; then
  other=$(echo "$json" | jq -r --arg c "$C" '[.spec.template.spec.containers[] | select(.name!=$c and .startupProbe != null) | .name] | join(",")')
  echo "ERR: container $C has no startupProbe${other:+ (found one on container '$other' instead)}"
  exit 1
fi

path=$(echo "$sp" | jq -r '.httpGet.path // empty')
port=$(echo "$sp" | jq -r '.httpGet.port // empty | tostring')
scheme=$(echo "$sp" | jq -r '.httpGet.scheme // "HTTP"')
period=$(echo "$sp" | jq -r '.periodSeconds // 10')
fail=$(echo "$sp" | jq -r '.failureThreshold // 3')
delay=$(echo "$sp" | jq -r '.initialDelaySeconds // 0')

if [ "$path" != "/" ] || { [ "$port" != "http" ] && [ "$port" != "80" ]; } || [ "$scheme" != "HTTP" ]; then
  echo "ERR: startupProbe must be the same HTTP check as the livenessProbe (GET / on port http), got path='$path' port='$port' scheme='$scheme'"
  exit 1
fi
[ "$period" = "5" ] || { echo "ERR: startupProbe periodSeconds is $period, expected 5"; exit 1; }
[ "$delay" = "0" ] || { echo "ERR: startupProbe has initialDelaySeconds $delay, expected no initial delay"; exit 1; }
[ "$fail" = "12" ] || { echo "ERR: startupProbe failureThreshold is $fail (${fail}x${period}s = $((fail*period))s), expected exactly 60s"; exit 1; }

echo "OK: $C has startupProbe GET / port $port every 5s, failureThreshold 12 (60s)"
exit 0
