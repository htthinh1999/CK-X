#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=orbit

if kubectl -n "$NS" get deployment telemetry-canary >/dev/null 2>&1; then
  echo "FAIL: Deployment telemetry-canary still exists"
  exit 1
fi

left=$(kubectl -n "$NS" get pods -l track=canary -o json 2>/dev/null | jq '[.items[] | select(.metadata.deletionTimestamp == null)] | length')
[ "${left:-0}" = "0" ] || { echo "FAIL: $left canary pod(s) still running"; exit 1; }

echo "PASS: canary Deployment and its pods are gone"
exit 0
