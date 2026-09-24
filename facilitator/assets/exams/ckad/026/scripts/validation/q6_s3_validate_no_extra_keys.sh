#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=lostproperty; CM=desk-config

keys=$(kubectl -n "$NS" get configmap "$CM" -o json 2>/dev/null | jq -r '[(.data // {}), (.binaryData // {}) | keys[]] | sort | join(",")') || { echo "FAIL: ConfigMap $CM not found"; exit 1; }
want="claim.window,contact.channel,desk.hours,desk.region,ledger.path,retention.days"
if [ "$keys" != "$want" ]; then
  echo "FAIL: $CM must gain only the keys that block the containers; expected keys $want, got $keys"
  exit 1
fi
echo "PASS: no keys beyond the blocking ones were added"
exit 0
