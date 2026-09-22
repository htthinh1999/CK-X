#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=starmap
REL=orrery-south
F=/home/candidate/exam/q1/south-values.yaml

[ -s "$F" ] || { echo "ERR: values file $F missing or empty"; exit 1; }
grep -q 'replicaCount' "$F" && grep -q 'south-ridge' "$F" || { echo "ERR: $F does not set replicaCount and the south-ridge annotation"; exit 1; }

info=$(helm -n "$NS" list -a -o json 2>/dev/null | jq -r --arg r "$REL" '.[] | select(.name==$r) | "\(.chart) \(.status)"' 2>/dev/null)
[ -n "$info" ] || { echo "ERR: release $REL not found in $NS"; exit 1; }
chart=${info% *}; st=${info##* }
case "$chart" in orrery-*) ;; *) echo "ERR: $REL uses chart '$chart', expected the local orrery chart"; exit 1;; esac
[ "$st" = "deployed" ] || { echo "ERR: $REL status is '$st'"; exit 1; }

helm -n "$NS" get values "$REL" -o json 2>/dev/null \
  | jq -e '((.replicaCount|tostring) == "2") and (.podAnnotations.site == "south-ridge")' >/dev/null 2>&1 \
  || { echo "ERR: $REL user values do not contain replicaCount=2 and podAnnotations.site=south-ridge"; exit 1; }

echo "OK: $REL installed from orrery with the expected values"
exit 0
