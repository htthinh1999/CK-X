#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=platform
ING=platform-board
HOST=board.transit.local

ing=$(kubectl -n "$NS" get ingress "$ING" -o json 2>/dev/null) || { echo "ERR: Ingress $ING not found in $NS"; exit 1; }
paths=$(echo "$ing" | jq -c --arg h "$HOST" '[.spec.rules[]? | select(.host==$h) | .http.paths[]?]')

# check_path <path> <service> <service port number>
check_path() {
  local p=$1 want_svc=$2 want_port=$3
  local entry n svc pnum pname ptype resolved
  n=$(echo "$paths" | jq --arg p "$p" '[.[] | select(.path==$p)] | length')
  [ "$n" = "1" ] || { echo "ERR: expected exactly one path $p for host $HOST, found $n"; exit 1; }
  entry=$(echo "$paths" | jq -c --arg p "$p" '.[] | select(.path==$p)')
  ptype=$(echo "$entry" | jq -r '.pathType // empty')
  [ "$ptype" = "Prefix" ] || { echo "ERR: path $p has pathType '$ptype', expected Prefix"; exit 1; }
  svc=$(echo "$entry" | jq -r '.backend.service.name // empty')
  [ "$svc" = "$want_svc" ] || { echo "ERR: path $p routes to Service '${svc:-none}', which does not front the expected Pods"; exit 1; }
  pnum=$(echo "$entry" | jq -r '.backend.service.port.number // empty')
  pname=$(echo "$entry" | jq -r '.backend.service.port.name // empty')
  s=$(kubectl -n "$NS" get service "$svc" -o json 2>/dev/null) || { echo "ERR: Service $svc not found"; exit 1; }
  if [ -n "$pnum" ]; then
    resolved=$(echo "$s" | jq -r --argjson n "$pnum" '.spec.ports[] | select(.port==$n) | .port')
  else
    resolved=$(echo "$s" | jq -r --arg n "$pname" '.spec.ports[] | select((.name // "")==$n) | .port')
  fi
  [ "$resolved" = "$want_port" ] || { echo "ERR: path $p uses port '${pnum}${pname}', which is not the Service port of $svc"; exit 1; }
}

check_path /departures departures 80
check_path /arrivals arrivals-live 8081

# the Services themselves must be unchanged
sel=$(kubectl -n "$NS" get service arrivals-live -o jsonpath='{.spec.selector.app}/{.spec.selector.track}' 2>/dev/null)
[ "$sel" = "arrivals/live" ] || { echo "ERR: Service arrivals-live selector was changed"; exit 1; }
sel=$(kubectl -n "$NS" get service departures -o jsonpath='{.spec.selector.app}/{.spec.selector.track}' 2>/dev/null)
[ "$sel" = "departures/live" ] || { echo "ERR: Service departures selector was changed"; exit 1; }

echo "OK: /departures -> departures:80 and /arrivals -> arrivals-live:8081 (Prefix)"
exit 0
