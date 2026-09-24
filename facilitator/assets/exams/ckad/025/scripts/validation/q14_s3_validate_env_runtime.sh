#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=almanac
P=almanac-reader

phase=$(kubectl -n "$NS" get pod "$P" -o jsonpath='{.status.phase}' 2>/dev/null)
[ "$phase" = "Running" ] || { echo "ERR: pod $P phase is '${phase:-<missing>}', expected Running"; exit 1; }

env=$(timeout 15 kubectl -n "$NS" exec "$P" -- env 2>/dev/null)
for kv in SUNRISE_SOURCE=usno TIDE_TABLE=pacific-north MOON_PHASE_API=v2 FORECAST_WINDOW=72h; do
  echo "$env" | grep -qx "$kv" || { echo "ERR: $kv not present in the environment of $P"; exit 1; }
done

echo "OK: all sky-settings keys are set as env vars in $P"
exit 0
