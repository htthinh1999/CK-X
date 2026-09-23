#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q11/blocker.txt

[ -s "$F" ] || { echo "FAIL: $F is missing or empty"; exit 1; }
got=$(tr -d '[:space:]' < "$F")
[ "$got" = "cache:memory" ] || { echo "FAIL: $F must name the blocking container and resource as <container>:<resource> (got '$got')"; exit 1; }
echo "PASS: blocking container and resource recorded"
exit 0
