#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q6/reason.txt

[ -s "$F" ] || { echo "FAIL: $F is missing or empty"; exit 1; }
got=$(tr -d '[:space:]' < "$F")
[ "$got" = "CreateContainerConfigError" ] || { echo "FAIL: $F must contain the exact waiting reason of the containers (got '$got')"; exit 1; }
echo "PASS: waiting reason recorded"
exit 0
