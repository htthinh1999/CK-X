#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
FILE=/home/candidate/exam/q18/can-i.txt

[ -f "$FILE" ] || { echo "ERR: $FILE not found"; exit 1; }
got=$(tr -d '\r' < "$FILE" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | sed '/^$/d' | awk '{print $1}' | tr '\n' ' ' | sed 's/ $//')

[ "$got" = "yes yes no" ] || { echo "ERR: $FILE holds '$got', expected the three can-i answers of the correctly configured ServiceAccount"; exit 1; }

echo "OK: $FILE holds yes / yes / no"
exit 0
