#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q9/exit-code.txt

[ -s "$F" ] || { echo "FAIL: $F is missing or empty"; exit 1; }
got=$(tr -d '[:space:]' < "$F")
[ "$got" = "23" ] || { echo "FAIL: $F does not hold the exit code that made the timetable-import Pods fail (got '$got')"; exit 1; }
echo "PASS: exit code recorded"
exit 0
