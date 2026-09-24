#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
FILE=/home/candidate/exam/q14/departures.out

[ -f "$FILE" ] || { echo "ERR: $FILE not found"; exit 1; }
line=$(tr -d '\r' < "$FILE" | grep -m1 'board=')
[ -n "$line" ] || { echo "ERR: $FILE does not contain a board response"; exit 1; }
for m in 'board=departures ' 'build=d-2291 ' 'host=board.transit.local ' 'xfh=board.transit.local ' 'uri=/departures/next'; do
  case "$line" in
    *"$m"*) ;;
    *) echo "ERR: response in $FILE lacks '${m% }' (got: $line)"; exit 1 ;;
  esac
done

echo "OK: $FILE is the departures board response served through Traefik"
exit 0
