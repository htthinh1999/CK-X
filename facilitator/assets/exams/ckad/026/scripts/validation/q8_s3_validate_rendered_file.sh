#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=signals
POD=signal-box

pod=$(kubectl -n "$NS" get pod "$POD" -o json 2>/dev/null) || { echo "ERR: Pod $POD not found in $NS"; exit 1; }
node=$(echo "$pod" | jq -r '.spec.nodeName // empty')
[ -n "$node" ] || { echo "ERR: Pod $POD is not scheduled"; exit 1; }

# /etc/signal in box must be an emptyDir that render also mounts
vol=$(echo "$pod" | jq -r '.spec.containers[] | select(.name=="box") | (.volumeMounts // [])[] | select((.mountPath|rtrimstr("/"))=="/etc/signal") | .name' | head -1)
[ -n "$vol" ] || { echo "ERR: container box has no volume mounted at /etc/signal"; exit 1; }
echo "$pod" | jq -e --arg v "$vol" '.spec.volumes[] | select(.name==$v) | has("emptyDir")' >/dev/null 2>&1 \
  || { echo "ERR: volume $vol mounted at /etc/signal is not an emptyDir"; exit 1; }
echo "$pod" | jq -e --arg v "$vol" '[(.spec.initContainers // [])[] | select(.name=="render") | (.volumeMounts // [])[] | select(.name==$v)] | length > 0' >/dev/null \
  || { echo "ERR: init container render does not mount volume $vol"; exit 1; }

expected=$(cat <<TPL
# signal box runtime configuration
box.id=$POD
box.interlocking=$node
box.cpu.millicores=250
box.aspects=4
box.log=/var/log/signal/$POD/$POD.log
TPL
)

got=$(timeout 20 kubectl -n "$NS" exec "$POD" -c box -- cat /etc/signal/box.conf 2>/dev/null) \
  || { echo "ERR: cannot read /etc/signal/box.conf in container box"; exit 1; }
got=$(printf '%s\n' "$got" | tr -d '\r' | sed 's/[[:space:]]*$//' | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}')

if [ "$got" != "$expected" ]; then
  echo "ERR: /etc/signal/box.conf does not match the rendered template"
  diff <(echo "$expected") <(echo "$got") | head -20
  exit 1
fi

echo "OK: /etc/signal/box.conf is the template rendered with $POD / $node / 250"
exit 0
