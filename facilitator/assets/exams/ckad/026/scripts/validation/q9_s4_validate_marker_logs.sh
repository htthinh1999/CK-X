#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=timetable; JOB=timetable-build

pods=$(kubectl -n "$NS" get pods -l batch.kubernetes.io/job-name="$JOB" -o json 2>/dev/null | jq -r '
  .items[] | select(.status.phase=="Succeeded")
  | "\(.metadata.annotations["batch.kubernetes.io/job-completion-index"] // "none") \(.metadata.name)"')
[ -n "$pods" ] || { echo "FAIL: no succeeded Pods of Job $JOB found"; exit 1; }

for i in 0 1 2 3 4 5; do
  ok=0
  while read -r pidx pname; do
    [ "$pidx" = "$i" ] || continue
    if kubectl -n "$NS" logs "$pname" --all-containers 2>/dev/null | grep -qE "^timetable shard $i built[[:space:]]*$"; then
      ok=1; break
    fi
  done <<< "$pods"
  [ "$ok" = "1" ] || { echo "FAIL: no succeeded Pod with completion index $i printed 'timetable shard $i built'"; exit 1; }
done
echo "PASS: every index 0-5 printed its marker line"
exit 0
