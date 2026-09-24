#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightly
CJ=star-catalog-sync

json=$(kubectl -n "$NS" get cronjob "$CJ" -o json 2>/dev/null) || { echo "FAIL: CronJob $CJ not found in namespace $NS"; exit 1; }

sc=$(echo "$json" | jq -c '[.spec.jobTemplate.spec.template.spec.containers[]? | select(.name == "sync")][0].securityContext // {}')

echo "$sc" | jq -e '.allowPrivilegeEscalation == false' >/dev/null \
  || { echo "FAIL: container sync must set allowPrivilegeEscalation: false (securityContext=$sc)"; exit 1; }
echo "$sc" | jq -e '(.capabilities.drop // []) | index("ALL") != null' >/dev/null \
  || { echo "FAIL: container sync must drop ALL capabilities (securityContext=$sc)"; exit 1; }

echo "OK: container sync disallows privilege escalation and drops ALL capabilities"
exit 0
