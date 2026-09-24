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

sel=$(echo "$json" | jq '.spec.podSelector // {}' | sel_str)
[ -n "$sel" ] || { echo "FAIL: podSelector is empty and selects every pod (expected tier=db)"; exit 1; }

matched=" $(kubectl -n "$NS" get pods -l "$sel" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null) "
case "$matched" in
  *" berth-db "*) ;;
  *) echo "FAIL: podSelector '$sel' does not select the berth-db pod"; exit 1 ;;
esac
for p in gate-ui dispatch-api; do
  case "$matched" in
    *" $p "*) echo "FAIL: podSelector '$sel' also selects $p (should select only tier=db pods)"; exit 1 ;;
  esac
done

echo "OK: berth-db-access applies to the tier=db pod only ($sel)"
exit 0
