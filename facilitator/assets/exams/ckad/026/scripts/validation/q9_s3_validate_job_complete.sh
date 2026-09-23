#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=timetable; JOB=timetable-build

json=$(kubectl -n "$NS" get job "$JOB" -o json 2>/dev/null) || { echo "FAIL: Job $JOB not found in $NS"; exit 1; }
succ=$(echo "$json" | jq -r '.status.succeeded // 0')
done_=$(echo "$json" | jq -r '[.status.conditions[]? | select(.type=="Complete" and .status=="True")] | length')
if [ "$succ" != "6" ] || [ "$done_" != "1" ]; then
  echo "FAIL: $JOB must be Complete with 6 succeeded Pods (succeeded=$succ, complete=$done_)"
  exit 1
fi
echo "PASS: $JOB is Complete with 6 succeeded Pods"
exit 0
