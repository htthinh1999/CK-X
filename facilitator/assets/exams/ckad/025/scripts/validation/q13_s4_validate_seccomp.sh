#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightly
CJ=star-catalog-sync

json=$(kubectl -n "$NS" get cronjob "$CJ" -o json 2>/dev/null) || { echo "FAIL: CronJob $CJ not found in namespace $NS"; exit 1; }

# Container-level profile (as asked); a pod-level profile inherited by the container is also accepted.
echo "$json" | jq -e '
  .spec.jobTemplate.spec.template.spec as $p
  | ([$p.containers[]? | select(.name == "sync")][0].securityContext.seccompProfile.type // $p.securityContext.seccompProfile.type // "") == "RuntimeDefault"' >/dev/null \
  || { echo "FAIL: container sync does not use seccompProfile type RuntimeDefault"; exit 1; }

echo "OK: container sync uses the RuntimeDefault seccomp profile"
exit 0
