#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightly
CJ=star-catalog-sync

json=$(kubectl -n "$NS" get cronjob "$CJ" -o json 2>/dev/null) || { echo "FAIL: CronJob $CJ not found in namespace $NS"; exit 1; }

sched=$(echo "$json" | jq -r '.spec.schedule // empty' | tr -s '[:space:]' ' ' | sed 's/^ //; s/ $//')
[ "$sched" = "15 3 * * *" ] || { echo "FAIL: schedule is '$sched', expected '15 3 * * *'"; exit 1; }

policy=$(echo "$json" | jq -r '.spec.concurrencyPolicy // empty')
[ "$policy" = "Forbid" ] || { echo "FAIL: concurrencyPolicy is '$policy', expected Forbid"; exit 1; }

deadline=$(echo "$json" | jq -r '.spec.startingDeadlineSeconds // empty')
[ "$deadline" = "200" ] || { echo "FAIL: startingDeadlineSeconds is '$deadline', expected 200"; exit 1; }

echo "$json" | jq -e '[.spec.jobTemplate.spec.template.spec.containers[]? | select(.name == "sync" and ((.image // "") | endswith("busybox:1.36")))] | length == 1' >/dev/null \
  || { echo "FAIL: no container 'sync' with image busybox:1.36 in the job template"; exit 1; }

echo "OK: CronJob $CJ schedule/concurrencyPolicy/startingDeadlineSeconds/container are correct"
exit 0
