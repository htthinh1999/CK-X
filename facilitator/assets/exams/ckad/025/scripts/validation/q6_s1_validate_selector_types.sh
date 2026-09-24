#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=relay
NP=collector-egress

np=$(kubectl -n "$NS" get networkpolicy "$NP" -o json 2>/dev/null) || { echo "ERR: NetworkPolicy $NP not found"; exit 1; }
echo "$np" | jq -e '.spec.podSelector.matchLabels == {"app":"collector"} and ((.spec.podSelector.matchExpressions // []) | length == 0)' >/dev/null 2>&1 \
  || { echo "ERR: podSelector is $(echo "$np" | jq -c '.spec.podSelector'), expected matchLabels app=collector"; exit 1; }
echo "$np" | jq -e '(.spec.policyTypes // []) == ["Egress"]' >/dev/null 2>&1 \
  || { echo "ERR: policyTypes is $(echo "$np" | jq -c '.spec.policyTypes'), expected [\"Egress\"] only"; exit 1; }

echo "OK: $NP selects app=collector with policyTypes [Egress]"
exit 0
