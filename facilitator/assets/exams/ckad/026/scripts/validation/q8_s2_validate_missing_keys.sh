#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=lostproperty; CM=desk-config

data=$(kubectl -n "$NS" get configmap "$CM" -o json 2>/dev/null | jq -c '.data // {}') || { echo "FAIL: ConfigMap $CM not found"; exit 1; }
[ -n "$data" ] || { echo "FAIL: ConfigMap $CM not found"; exit 1; }

check() {
  local k="$1" want="$2" got
  got=$(echo "$data" | jq -r --arg k "$k" '.[$k] // "<missing>"')
  if [ "$got" != "$want" ]; then
    echo "FAIL: $CM key $k must be '$want' (got '$got')"
    exit 1
  fi
}
# keys that were missing and block container start
check claim.window 45d
check ledger.path /var/ledger/claims.db
# keys that already existed must be untouched
check desk.region north-concourse
check desk.hours 06:00-22:00
check retention.days 90
check contact.channel desk-ops

echo "PASS: $CM now has claim.window and ledger.path with the approved values; existing keys unchanged"
exit 0
