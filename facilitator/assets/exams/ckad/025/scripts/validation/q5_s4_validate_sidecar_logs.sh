#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectra
P=prism

logs=$(timeout 15 kubectl -n "$NS" logs "$P" -c log-tailer --tail=200 2>/dev/null)
echo "$logs" | grep -Eq 'spectral-line [0-9]+' && { echo "OK: log-tailer streams the emitter's log lines"; exit 0; }
echo "ERR: 'kubectl logs $P -c log-tailer' shows no 'spectral-line <n>' entries"
exit 1
