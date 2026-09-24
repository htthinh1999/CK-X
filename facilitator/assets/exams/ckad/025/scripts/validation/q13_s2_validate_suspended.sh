#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightly
CJ=star-catalog-sync

suspend=$(kubectl -n "$NS" get cronjob "$CJ" -o jsonpath='{.spec.suspend}' 2>/dev/null) || { echo "FAIL: CronJob $CJ not found in namespace $NS"; exit 1; }
[ "$suspend" = "true" ] || { echo "FAIL: CronJob $CJ spec.suspend is '$suspend', expected true"; exit 1; }

echo "OK: CronJob $CJ is suspended"
exit 0
