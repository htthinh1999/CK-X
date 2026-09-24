#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n tides get configmap gauge-config -o json 2>/dev/null) || { echo "ERR: configmap gauge-config not found in tides"; exit 1; }
keys=$(echo "$j" | jq -r '[((.data // {}) | keys[]), ((.binaryData // {}) | keys[])] | join(",")')
[ "$keys" = "station.conf" ] || { echo "ERR: expected exactly one key 'station.conf', found '$keys'"; exit 1; }
got=$(echo "$j" | jq -r '.data["station.conf"] // ""' | sed 's/[[:space:]]*$//')
exp=$(printf '%s\n' "station.id=WG-17" "sample.interval.seconds=30" "tide.datum=LAT" "alert.high.water.cm=520")
[ "$got" = "$exp" ] && { echo "OK: station.conf holds the gauge.properties content"; exit 0; }
echo "ERR: station.conf content does not match /home/candidate/exam/q1/gauge.properties"; exit 1
