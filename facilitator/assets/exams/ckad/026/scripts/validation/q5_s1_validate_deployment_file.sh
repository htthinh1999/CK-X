#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q5/deployment.txt

[ -s "$F" ] || { echo "ERR: $F missing or empty"; exit 1; }
val=$(tr -d '[:space:]' < "$F")
[ "$val" = "sleeper-berths" ] || { echo "ERR: $F contains '$val', which is not the Deployment killed by its liveness probe"; exit 1; }

echo "OK: Deployment identified as sleeper-berths"
exit 0
