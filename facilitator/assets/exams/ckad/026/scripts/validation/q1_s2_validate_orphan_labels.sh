#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=ticketing
EXPECTED="barrier-api-key fare-rules legacy-smartcard-key promo-codes-2024"

json=$(kubectl -n "$NS" get secrets -o json 2>/dev/null) || { echo "ERR: cannot list Secrets in $NS"; exit 1; }

for s in $EXPECTED; do
  echo "$json" | jq -e --arg n "$s" '.items[] | select(.metadata.name==$n)' >/dev/null 2>&1 \
    || { echo "ERR: Secret $s no longer exists"; exit 1; }
done

labeled=$(echo "$json" | jq -r '[.items[] | select(.metadata.labels.lifecycle=="orphaned") | .metadata.name] | sort | join(" ")')

if [ "$labeled" != "$EXPECTED" ]; then
  echo "ERR: Secrets labeled lifecycle=orphaned are [$labeled], expected [$EXPECTED]"
  exit 1
fi

echo "OK: exactly the orphaned Opaque Secrets carry lifecycle=orphaned"
exit 0
