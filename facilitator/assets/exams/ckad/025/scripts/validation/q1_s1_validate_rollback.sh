#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=starmap
REL=orrery-north

hist=$(helm -n "$NS" history "$REL" -o json 2>/dev/null) || { echo "ERR: release $REL not found in $NS"; exit 1; }
last=$(echo "$hist" | jq -c 'max_by(.revision)' 2>/dev/null)
rev=$(echo "$last" | jq -r '.revision // empty' 2>/dev/null)
st=$(echo "$last" | jq -r '.status // empty' 2>/dev/null)
desc=$(echo "$last" | jq -r '.description // empty' 2>/dev/null)

[ "${rev:-0}" -ge 3 ] 2>/dev/null || { echo "ERR: current revision is ${rev:-none}, expected a new revision created by the rollback"; exit 1; }
[ "$st" = "deployed" ] || { echo "ERR: revision $rev status is '$st', expected deployed"; exit 1; }
echo "$desc" | grep -q "Rollback to 1" || { echo "ERR: revision $rev is '$desc', expected a rollback to revision 1"; exit 1; }

echo "OK: $REL revision $rev is deployed ($desc)"
exit 0
