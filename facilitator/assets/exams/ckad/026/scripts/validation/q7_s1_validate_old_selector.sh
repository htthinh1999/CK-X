#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q7/old-selector.txt

[ -s "$F" ] || { echo "FAIL: $F is missing or empty"; exit 1; }
got=$(tr -d '[:space:]' < "$F")
want="app=junction,slot=blue,tier=web"
if [ "$got" != "$want" ]; then
  echo "FAIL: $F must contain the previous selector as sorted key=value pairs (got '$got')"
  exit 1
fi
echo "PASS: previous selector recorded as $want"
exit 0
