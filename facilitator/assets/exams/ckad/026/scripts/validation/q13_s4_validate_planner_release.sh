#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=helmyard
REL=route-planner

hist=$(helm -n "$NS" history "$REL" -o json 2>/dev/null) || { echo "ERR: release $REL not found in $NS"; exit 1; }
first=$(echo "$hist" | jq -r 'min_by(.revision).revision' 2>/dev/null)
rev=$(echo "$hist" | jq -r 'max_by(.revision).revision' 2>/dev/null)
st=$(echo "$hist" | jq -r 'max_by(.revision).status' 2>/dev/null)
chart=$(echo "$hist" | jq -r 'max_by(.revision).chart' 2>/dev/null)

[ "$first" = "1" ] && [ "${rev:-0}" -ge 2 ] 2>/dev/null || { echo "ERR: $REL was not upgraded in place (revisions ${first:-?}..${rev:-?})"; exit 1; }
[ "$st" = "deployed" ] || { echo "ERR: $REL revision $rev has status '$st', expected deployed"; exit 1; }
[ "$chart" = "depot-web-0.2.0" ] || { echo "ERR: $REL uses chart '$chart', expected depot-web-0.2.0"; exit 1; }

vals=$(helm -n "$NS" get values "$REL" -o json 2>/dev/null)
[ -n "$vals" ] || { echo "ERR: cannot read user-supplied values of $REL"; exit 1; }
# compare with the original user-supplied values (null entries ignored)
exp='{"replicaCount":2,"podAnnotations":{"transit.example/zone":"north-yard"},"podLabels":{"lane":"express"},"resources":{"limits":{"memory":"64Mi"}}}'
norm='walk(if type == "object" then with_entries(select(.value != null)) else . end) | walk(if type == "number" then tostring else . end)'
got=$(echo "$vals" | jq -cS "$norm" 2>/dev/null)
want=$(echo "$exp" | jq -cS "$norm")
if [ "$got" != "$want" ]; then
  echo "ERR: user-supplied values of $REL changed: got $got, expected $want"
  exit 1
fi

echo "OK: $REL is deployed from depot-web-0.2.0 with its original user-supplied values"
exit 0
