#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=calibration
CM=optics-v2

json=$(kubectl -n "$NS" get configmap "$CM" -o json 2>/dev/null) || { echo "FAIL: ConfigMap $CM not found in namespace $NS"; exit 1; }

echo "$json" | jq -e '.immutable == true' >/dev/null || { echo "FAIL: ConfigMap $CM is not immutable"; exit 1; }

trim() { local s="$1"; s="${s%"${s##*[![:space:]]}"}"; printf '%s' "$s"; }

keys=$(echo "$json" | jq -r '(.data // {}) | keys | length')
[ "$keys" = "3" ] || { echo "FAIL: ConfigMap $CM has $keys keys, expected exactly 3"; exit 1; }

for pair in FOCAL_LENGTH=2400 APERTURE=f11 FILTER=h-alpha; do
  k="${pair%%=*}"; want="${pair#*=}"
  got=$(trim "$(echo "$json" | jq -r --arg k "$k" '.data[$k] // empty')")
  [ "$got" = "$want" ] || { echo "FAIL: $CM key $k='$got', expected '$want'"; exit 1; }
done

echo "OK: immutable ConfigMap $CM has the expected data"
exit 0
