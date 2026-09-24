#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=helmyard
REL=stop-indexer

hist=$(helm -n "$NS" history "$REL" -o json 2>/dev/null) || { echo "ERR: release $REL not found in $NS"; exit 1; }
first=$(echo "$hist" | jq -r 'min_by(.revision).revision' 2>/dev/null)
first_desc=$(echo "$hist" | jq -r 'min_by(.revision) | "\(.status) \(.description)"' 2>/dev/null)
rev=$(echo "$hist" | jq -r 'max_by(.revision).revision' 2>/dev/null)
st=$(echo "$hist" | jq -r 'max_by(.revision).status' 2>/dev/null)
chart=$(echo "$hist" | jq -r 'max_by(.revision).chart' 2>/dev/null)

if [ "$first" != "1" ] || ! echo "$first_desc" | grep -qi 'fail'; then
  echo "ERR: the original failed revision 1 of $REL is not in its history; the release was re-created instead of repaired with an upgrade"
  exit 1
fi
[ "${rev:-0}" -ge 2 ] 2>/dev/null || { echo "ERR: $REL has no revision after the failed install (latest is ${rev:-none})"; exit 1; }
[ "$st" = "deployed" ] || { echo "ERR: $REL revision $rev has status '$st', expected deployed"; exit 1; }
[ "$chart" = "depot-web-0.1.0" ] || { echo "ERR: $REL uses chart '$chart', it must stay on depot-web-0.1.0"; exit 1; }

vals=$(helm -n "$NS" get values "$REL" -o json 2>/dev/null)
[ -n "$vals" ] || { echo "ERR: cannot read user-supplied values of $REL"; exit 1; }
echo "$vals" | jq -e '((.image.tag // "") | tostring) == "1.26"' >/dev/null 2>&1 \
  || { echo "ERR: user-supplied image.tag of $REL is '$(echo "$vals" | jq -r '.image.tag // "unset"')', expected 1.26"; exit 1; }
echo "$vals" | jq -e '((.replicaCount // "") | tostring) == "3" and (.podLabels.lane == "local")' >/dev/null 2>&1 \
  || { echo "ERR: $REL lost its other user-supplied values (replicaCount 3, podLabels.lane=local)"; exit 1; }
echo "$vals" | jq -e '(.image.repository // "nginx") == "nginx"' >/dev/null 2>&1 \
  || { echo "ERR: $REL overrides image.repository"; exit 1; }

echo "OK: $REL repaired by upgrade to revision $rev (deployed, depot-web-0.1.0, values kept)"
exit 0
