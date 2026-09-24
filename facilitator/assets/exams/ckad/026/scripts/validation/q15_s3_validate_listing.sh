#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=manifests
F=/home/candidate/exam/q15/routes.txt

[ -s "$F" ] || { echo "ERR: $F missing or empty"; exit 1; }
live=$(kubectl -n "$NS" get routes.transit.example.com -o json 2>/dev/null) || { echo "ERR: cannot list transit Routes in $NS"; exit 1; }
echo "$live" | jq -e '[.items[].metadata.name] | (index("f1-islands") != null) and (index("n9-nightliner") != null)' >/dev/null \
  || { echo "ERR: f1-islands and n9-nightliner must exist before the listing is written"; exit 1; }

want=$(echo "$live" | jq -r '.items | sort_by(.spec.stops) | .[] | "\(.metadata.name) \(.spec.line) \(.spec.serviceClass // "<none>") \(.spec.stops)"')
got=$(sed 's/\r$//' "$F" | tr -s ' \t' '  ' | sed 's/^ //; s/ $//' | grep -v '^$')

if [ "$got" != "$want" ]; then
  n=$(echo "$want" | wc -l)
  first=$(echo "$got" | head -1)
  echo "ERR: $F does not match the $n transit Routes in $NS (name line serviceClass stops, sorted by stops, no header); first line is '$first'"
  exit 1
fi

echo "OK: $F lists all $(echo "$want" | wc -l) transit Routes sorted by stops"
exit 0
