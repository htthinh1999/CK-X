#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=timetable; JOB=timetable-build

json=$(kubectl -n "$NS" get job "$JOB" -o json 2>/dev/null) || { echo "FAIL: Job $JOB not found in $NS"; exit 1; }

chk() {
  local what="$1" filter="$2" want="$3" got
  got=$(echo "$json" | jq -r "$filter")
  [ "$got" = "$want" ] || { echo "FAIL: $what must be $want (got $got)"; exit 1; }
}
chk completions        '.spec.completions'             6
chk parallelism        '.spec.parallelism'             3
chk completionMode     '.spec.completionMode'          Indexed
chk backoffLimit       '.spec.backoffLimit'            2
chk activeDeadlineSeconds  '.spec.activeDeadlineSeconds'   240
chk ttlSecondsAfterFinished '.spec.ttlSecondsAfterFinished' 86400
chk "container image"  '[.spec.template.spec.containers[].image] | join(",")' busybox:1.36

echo "PASS: $JOB spec has the requested completions, parallelism, mode, limits and TTL"
exit 0
