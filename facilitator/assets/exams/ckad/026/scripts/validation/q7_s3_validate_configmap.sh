#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=fares

json=$(kubectl -n "$NS" get configmap fare-table -o json 2>/dev/null) || { echo "ERR: ConfigMap fare-table not found"; exit 1; }
trim() { printf '%s' "$1" | tr -s '[:space:]' ' ' | sed 's/^ //; s/ $//'; }
peak=$(trim "$(echo "$json" | jq -r '.data["peak.txt"] // empty')")
off=$(trim "$(echo "$json" | jq -r '.data["offpeak.txt"] // empty')")
night=$(trim "$(echo "$json" | jq -r '.data["night.txt"] // empty')")

[ "$peak" = "PEAK 3.95" ] || { echo "ERR: fare-table peak.txt is '$peak', expected 'PEAK 3.95'"; exit 1; }
[ "$off" = "OFFPEAK 2.40" ] && [ "$night" = "NIGHT 4.00" ] || { echo "ERR: other keys of fare-table were changed (offpeak.txt='$off', night.txt='$night')"; exit 1; }

echo "OK: fare-table peak.txt is 'PEAK 3.95', other keys unchanged"
exit 0
