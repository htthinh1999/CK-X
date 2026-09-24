#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectra
P=prism

j=$(kubectl -n "$NS" get pod "$P" -o json 2>/dev/null) || { echo "ERR: pod $P not found"; exit 1; }
echo "$j" | jq -e '
  ([.spec.volumes[]? | select(.name=="logs" and has("emptyDir"))] | length > 0)
  and ([.spec.containers[]? | select(.name=="emitter") | .volumeMounts[]? | select(.name=="logs" and .mountPath=="/var/log/prism")] | length > 0)
  and ([.spec.initContainers[]? | select(.name=="log-tailer") | .volumeMounts[]? | select(.name=="logs" and .mountPath=="/var/log/prism")] | length > 0)
' >/dev/null 2>&1 && { echo "OK: emptyDir logs mounted at /var/log/prism in emitter and log-tailer"; exit 0; }
echo "ERR: emptyDir volume 'logs' must be mounted at /var/log/prism in both emitter and log-tailer"
exit 1
