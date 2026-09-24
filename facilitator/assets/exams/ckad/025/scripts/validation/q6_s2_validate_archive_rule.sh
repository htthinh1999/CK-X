#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=relay
NP=collector-egress

np=$(kubectl -n "$NS" get networkpolicy "$NP" -o json 2>/dev/null) || { echo "ERR: NetworkPolicy $NP not found"; exit 1; }
echo "$np" | jq -e '
  [ .spec.egress[]?
    | select(any(.to[]?; .podSelector.matchLabels.app == "archive"))
    | select(any(.ports[]?; ((.protocol // "TCP") == "TCP") and ((.port | tostring) == "6379")))
  ] | length > 0' >/dev/null 2>&1 \
  && { echo "OK: egress rule to app=archive on TCP 6379 present"; exit 0; }
echo "ERR: no egress rule with to.podSelector app=archive and TCP port 6379"
exit 1
