#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=kiosk

kubectl -n "$NS" get networkpolicy kiosk-ingress >/dev/null 2>&1 || { echo "ERR: NetworkPolicy kiosk-ingress not found in $NS"; exit 1; }
ip=$(kubectl -n "$NS" get pods -l app=kiosk --field-selector=status.phase=Running -o json 2>/dev/null | jq -r '[.items[] | select(.metadata.deletionTimestamp == null and .status.podIP != null)][0].status.podIP // empty')
[ -n "$ip" ] || { echo "ERR: no running kiosk Pod"; exit 1; }

# prints REACHED / BLOCKED, anything else means the test could not run
probe() {
  timeout 20 kubectl -n "$1" exec "$2" -- sh -c "if timeout 4 wget -q -T 3 -O /dev/null http://$ip:$3/ 2>/dev/null; then echo REACHED; else echo BLOCKED; fi" 2>/dev/null | tail -1
}
# expect <ns> <pod> <port> <REACHED|BLOCKED> <what>
expect() {
  local r; r=$(probe "$1" "$2" "$3")
  case "$r" in
    REACHED|BLOCKED) ;;
    *) echo "ERR: could not run the test from $1/$2 (Pod missing or not running?)"; exit 1;;
  esac
  if [ "$r" != "$4" ]; then
    if [ "$4" = "REACHED" ]; then
      echo "ERR: $1/$2 cannot reach kiosk $ip:$3 ($5), expected allowed"
    else
      echo "ERR: $1/$2 reaches kiosk $ip:$3 ($5), expected blocked"
    fi
    exit 1
  fi
}

expect ops-east monitor 80 REACHED "role=monitor in a team=ops namespace"
expect ops-east guest 80 BLOCKED "role=guest"
expect ops-west monitor 80 BLOCKED "namespace ops-west is team=dev"

echo "OK: ops-east/monitor reaches kiosk:80; ops-east/guest and ops-west/monitor are blocked"
exit 0
