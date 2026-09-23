#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=sleepers; DEP=sleeper-berths

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }

norm='def n: if . == null then null else {h: (if .httpGet then {path: .httpGet.path, port: (.httpGet.port | tostring | if . == "80" then "http" else . end), scheme: (.httpGet.scheme // "HTTP"), host: .httpGet.host, headers: .httpGet.httpHeaders} else null end), e: .exec, t: .tcpSocket, g: .grpc, i: (.initialDelaySeconds // 0), p: (.periodSeconds // 10), to: (.timeoutSeconds // 1), s: (.successThreshold // 1), f: (.failureThreshold // 3), tg: .terminationGracePeriodSeconds} end; n'
w=$(echo "$json" | jq -c '[.spec.template.spec.containers[] | select(.name=="warmer")][0]')
[ "$w" != "null" ] || { echo "ERR: container warmer not found"; exit 1; }
echo "$w" | jq -e '.startupProbe != null' >/dev/null 2>&1 || { echo "ERR: container warmer has no startupProbe yet (nothing to compare)"; exit 1; }

live=$(echo "$w" | jq -cS ".livenessProbe | $norm")
want_live=$(echo '{"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":5,"periodSeconds":5,"timeoutSeconds":1,"failureThreshold":3}' | jq -cS "$norm")
[ "$live" = "$want_live" ] || { echo "ERR: livenessProbe of warmer was changed"; exit 1; }

ready=$(echo "$w" | jq -cS ".readinessProbe | $norm")
want_ready=$(echo '{"httpGet":{"path":"/","port":"http"},"periodSeconds":5}' | jq -cS "$norm")
[ "$ready" = "$want_ready" ] || { echo "ERR: readinessProbe of warmer was changed"; exit 1; }

got=$(echo "$json" | jq -c '[.spec.template.spec.containers[] | {name, image, command, args}] | sort_by(.name)')
want='[{"name":"log-tail","image":"busybox:1.36","command":["sh","-c","while true; do sleep 3600; done"],"args":null},{"name":"warmer","image":"nginx:1.25","command":["sh","-c","echo '"'"'loading berth allocation map, this takes about 40s'"'"'; sleep 40 & wait $!; echo '"'"'map loaded'"'"'; exec nginx -g '"'"'daemon off;'"'"'"],"args":null}]'
want=$(echo "$want" | jq -c '.')
[ "$got" = "$want" ] || { echo "ERR: containers, images or commands of $DEP were changed"; exit 1; }

echo "OK: livenessProbe, readinessProbe, images and commands unchanged"
exit 0
