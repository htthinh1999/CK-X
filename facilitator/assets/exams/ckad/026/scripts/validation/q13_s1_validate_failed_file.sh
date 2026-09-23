#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q13/failed-release.txt

[ -s "$F" ] || { echo "ERR: $F missing or empty"; exit 1; }
val=$(tr -d '[:space:]' < "$F")
[ "$val" = "stop-indexer" ] || { echo "ERR: $F contains '$val', which is not the release that is in status failed"; exit 1; }

echo "OK: failed release identified as stop-indexer"
exit 0
