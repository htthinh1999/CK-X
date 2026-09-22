#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightwatch
F=/home/candidate/exam/q13/crash.log

[ -s "$F" ] || { echo "FAIL: $F missing or empty"; exit 1; }

if grep -q "standing by" "$F"; then
  echo "FAIL: $F contains output of the current (restarted) container, expected only the previous instance"
  exit 1
fi

marker=$(kubectl -n "$NS" logs insomniac --previous 2>/dev/null | grep 'FATAL' | head -n1 | sed 's/[[:space:]]*$//')
if [ -n "$marker" ]; then
  grep -qF -- "$marker" "$F" || { echo "FAIL: $F does not contain the crash line of the previous container: $marker"; exit 1; }
else
  grep -qE 'FATAL: guide-star lock lost \(token=[0-9]+\)' "$F" || { echo "FAIL: $F does not contain the crash line of the previous container"; exit 1; }
fi

echo "OK: $F holds the previous (crashed) container logs"
exit 0
