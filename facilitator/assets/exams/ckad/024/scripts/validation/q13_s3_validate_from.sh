#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=pier
# Convert a LabelSelector JSON object (stdin) into a kubectl -l selector string
sel_str() {
  jq -r '[ (.matchLabels // {} | to_entries[] | "\(.key)=\(.value)"),
           ((.matchExpressions // [])[] |
              if .operator == "In" then "\(.key) in (\(.values | join(",")))"
              elif .operator == "NotIn" then "\(.key) notin (\(.values | join(",")))"
              elif .operator == "Exists" then .key
              else "!\(.key)" end) ] | join(",")'
}

json=$(kubectl -n "$NS" get networkpolicy berth-db-access -o json 2>/dev/null) || { echo "FAIL: networkpolicy berth-db-access not found in $NS"; exit 1; }

nrules=$(echo "$json" | jq '(.spec.ingress // []) | length')
[ "$nrules" = "1" ] || { echo "FAIL: expected exactly 1 ingress rule, found $nrules"; exit 1; }
npeers=$(echo "$json" | jq '(.spec.ingress[0].from // []) | length')
[ "$npeers" = "1" ] || { echo "FAIL: expected exactly 1 'from' peer in the ingress rule, found $npeers"; exit 1; }

peer=$(echo "$json" | jq -c '.spec.ingress[0].from[0]')
[ -z "$(echo "$peer" | jq -c '.ipBlock // empty')" ] || { echo "FAIL: 'from' peer uses an ipBlock"; exit 1; }
nss=$(echo "$peer" | jq -c '.namespaceSelector // empty')
if [ -n "$nss" ] && [ "$nss" != '{"matchLabels":{"kubernetes.io/metadata.name":"pier"}}' ]; then
  echo "FAIL: 'from' peer has namespaceSelector $nss (traffic must come from namespace pier only)"; exit 1
fi
[ "$(echo "$peer" | jq -r 'has("podSelector")')" = "true" ] || { echo "FAIL: 'from' peer has no podSelector"; exit 1; }

sel=$(echo "$peer" | jq '.podSelector' | sel_str)
[ -n "$sel" ] || { echo "FAIL: 'from' podSelector is empty and allows every pod (expected tier=backend)"; exit 1; }

matched=" $(kubectl -n "$NS" get pods -l "$sel" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null) "
case "$matched" in
  *" dispatch-api "*) ;;
  *) echo "FAIL: 'from' podSelector '$sel' does not select the dispatch-api (tier=backend) pod"; exit 1 ;;
esac
for p in gate-ui berth-db; do
  case "$matched" in
    *" $p "*) echo "FAIL: 'from' podSelector '$sel' also allows $p"; exit 1 ;;
  esac
done

echo "OK: ingress is allowed only from tier=backend pods ($sel)"
exit 0
