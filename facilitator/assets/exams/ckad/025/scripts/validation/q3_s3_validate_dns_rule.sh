#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=relay
NP=collector-egress

np=$(kubectl -n "$NS" get networkpolicy "$NP" -o json 2>/dev/null) || { echo "ERR: NetworkPolicy $NP not found"; exit 1; }
protos=$(echo "$np" | jq -c '[ .spec.egress[]?.ports[]? | select((.port | tostring) == "53") | (.protocol // "TCP") ] | unique' 2>/dev/null)
echo "$protos" | jq -e 'any(.[]; . == "UDP") and any(.[]; . == "TCP")' >/dev/null 2>&1 \
  && { echo "OK: DNS allowed on port 53 over $protos"; exit 0; }
echo "ERR: port 53 egress protocols are ${protos:-[]}, expected both UDP and TCP"
exit 1
