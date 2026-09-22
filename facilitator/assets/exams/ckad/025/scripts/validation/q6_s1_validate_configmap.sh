#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=almanac
CM=sky-settings

j=$(kubectl -n "$NS" get configmap "$CM" -o json 2>/dev/null) || { echo "ERR: ConfigMap $CM not found"; exit 1; }
echo "$j" | jq -e '(.data // {}) == {"SUNRISE_SOURCE":"usno","TIDE_TABLE":"pacific-north","MOON_PHASE_API":"v2","FORECAST_WINDOW":"72h"}' >/dev/null 2>&1 \
  && { echo "OK: $CM holds the 4 env-file keys"; exit 0; }
echo "ERR: $CM data is $(echo "$j" | jq -c '.data // {}'), expected one key per variable in almanac.env"
exit 1
