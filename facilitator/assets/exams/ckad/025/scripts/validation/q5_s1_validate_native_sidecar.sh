#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectra
P=prism

j=$(kubectl -n "$NS" get pod "$P" -o json 2>/dev/null) || { echo "ERR: pod $P not found"; exit 1; }
sc=$(echo "$j" | jq -c '[.spec.initContainers[]? | select(.name=="log-tailer")][0] // empty')
[ -n "$sc" ] || { echo "ERR: no init container named log-tailer"; exit 1; }
rp=$(echo "$sc" | jq -r '.restartPolicy // empty')
img=$(echo "$sc" | jq -r '.image // empty')
[ "$rp" = "Always" ] || { echo "ERR: log-tailer restartPolicy is '${rp:-<unset>}', expected Always"; exit 1; }
[ "$img" = "busybox:1.36" ] || { echo "ERR: log-tailer image is '$img', expected busybox:1.36"; exit 1; }
echo "$j" | jq -e 'any(.spec.containers[]; .name=="emitter" and .image=="busybox:1.36")' >/dev/null 2>&1 \
  || { echo "ERR: main container emitter (busybox:1.36) not found"; exit 1; }

echo "OK: log-tailer is a native sidecar (restartPolicy Always)"
exit 0
