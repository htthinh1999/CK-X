#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=survey
F=/home/candidate/exam/q4/pod-ips.sh

[ -s "$F" ] || { echo "ERR: $F missing or empty"; exit 1; }
grep -q 'kubectl' "$F" || { echo "ERR: $F does not call kubectl"; exit 1; }
grep -q 'custom-columns' "$F" || { echo "ERR: $F does not use custom-columns"; exit 1; }

# Run the command with a private kubeconfig copy whose namespace is 'default'.
TMPK=$(mktemp)
trap 'rm -f "$TMPK"' EXIT
kubectl config view --raw > "$TMPK" 2>/dev/null
KUBECONFIG="$TMPK" kubectl config set-context --current --namespace=default >/dev/null 2>&1

# Normalise column spacing: collapse runs of whitespace to one space
out=$(cd /tmp && KUBECONFIG="$TMPK" timeout 30 bash "$F" 2>/dev/null | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//' | sed '/^$/d')
hdr=$(echo "$out" | head -n 1)
rows=$(echo "$out" | tail -n +2 | sort)
exp=$(kubectl -n "$NS" get pods -o json 2>/dev/null | jq -r '.items[] | "\(.metadata.name) \(.status.podIP // "<none>")"' | sort)

[ -n "$exp" ] || { echo "ERR: no pods found in $NS"; exit 1; }
[ "$hdr" = "NAME POD_IP" ] || { echo "ERR: header is '$hdr', expected 'NAME POD_IP'"; exit 1; }
[ "$rows" = "$exp" ] && { echo "OK: NAME/POD_IP rows match"; exit 0; }
echo "ERR: rows do not match."
echo "--- expected"; echo "$exp"
echo "--- got"; echo "$rows"
exit 1
