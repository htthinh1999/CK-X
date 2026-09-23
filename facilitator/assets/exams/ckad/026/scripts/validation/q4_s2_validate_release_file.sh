#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
FILE=/home/candidate/exam/q4/release.txt

[ -f "$FILE" ] || { echo "ERR: $FILE not found"; exit 1; }
got=$(tr -d '\r' < "$FILE" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | sed '/^$/d')
got=${got#\"}; got=${got%\"}

[ "$got" = "riverside-417" ] || { echo "ERR: $FILE contains '$got', expected the value of label transit.dispatch/release of the built image"; exit 1; }

echo "OK: $FILE holds the release label value"
exit 0
