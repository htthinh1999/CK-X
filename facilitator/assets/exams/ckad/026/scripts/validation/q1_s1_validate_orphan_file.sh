#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
FILE=/home/candidate/exam/q1/orphaned-secrets.txt
EXPECTED="barrier-api-key
fare-rules
legacy-smartcard-key
promo-codes-2024"

[ -f "$FILE" ] || { echo "ERR: $FILE not found"; exit 1; }

# one name per line; ignore CR, surrounding whitespace and blank lines
got=$(tr -d '\r' < "$FILE" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | sed '/^$/d')

if [ "$got" != "$EXPECTED" ]; then
  echo "ERR: $FILE does not list exactly the unreferenced Opaque Secrets in sorted order"
  echo "got: $(echo "$got" | tr '\n' ' ')"
  exit 1
fi

echo "OK: $FILE lists the 4 unreferenced Opaque Secrets in order"
exit 0
