#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=survey
F=/home/candidate/exam/q9/oldest-first.sh

[ -s "$F" ] || { echo "ERR: $F missing or empty"; exit 1; }
grep -q 'kubectl' "$F" || { echo "ERR: $F does not call kubectl"; exit 1; }

# Run the command with a private kubeconfig copy whose namespace is 'default',
# so the file must select namespace survey itself.
TMPK=$(mktemp)
trap 'rm -f "$TMPK"' EXIT
kubectl config view --raw > "$TMPK" 2>/dev/null
KUBECONFIG="$TMPK" kubectl config set-context --current --namespace=default >/dev/null 2>&1

out=$(cd /tmp && KUBECONFIG="$TMPK" timeout 30 bash "$F" 2>/dev/null | sed 's/[[:space:]]*$//' | sed '/^$/d')
exp=$(kubectl -n "$NS" get pods -o json 2>/dev/null | jq -r '.items | sort_by(.metadata.creationTimestamp) | .[].metadata.name')

[ -n "$exp" ] || { echo "ERR: no pods found in $NS"; exit 1; }
[ "$out" = "$exp" ] && { echo "OK: output matches pods sorted by creation time"; exit 0; }
echo "ERR: output does not match."
echo "--- expected"; echo "$exp"
echo "--- got"; echo "$out"
exit 1
