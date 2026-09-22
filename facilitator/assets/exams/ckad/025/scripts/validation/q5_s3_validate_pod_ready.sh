#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectra
P=prism

j=$(kubectl -n "$NS" get pod "$P" -o json 2>/dev/null) || { echo "ERR: pod $P not found"; exit 1; }
phase=$(echo "$j" | jq -r '.status.phase // empty')
ready=$(echo "$j" | jq -r '[.status.conditions[]? | select(.type=="Ready")][0].status // empty')
sc_run=$(echo "$j" | jq -r '[.status.initContainerStatuses[]? | select(.name=="log-tailer")][0].state.running.startedAt // empty')
main_ready=$(echo "$j" | jq -r '[.status.containerStatuses[]? | select(.name=="emitter")][0].ready // false')

[ "$phase" = "Running" ] || { echo "ERR: pod phase is '$phase', expected Running"; exit 1; }
[ "$ready" = "True" ] || { echo "ERR: pod Ready condition is '$ready'"; exit 1; }
[ -n "$sc_run" ] || { echo "ERR: sidecar log-tailer is not running"; exit 1; }
[ "$main_ready" = "true" ] || { echo "ERR: container emitter is not ready"; exit 1; }

echo "OK: pod $P Running and Ready with sidecar running"
exit 0
