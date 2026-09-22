#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=calibration
DEP=lens-calibrator
KEY=observatory.io/optics-checksum
WANT=9f2c41ab

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in namespace $NS"; exit 1; }

got=$(echo "$json" | jq -r --arg k "$KEY" '.spec.template.metadata.annotations[$k] // empty')
got="${got%"${got##*[![:space:]]}"}"
[ "$got" = "$WANT" ] || { echo "FAIL: pod template annotation $KEY='$got', expected '$WANT'"; exit 1; }

echo "OK: pod template annotation $KEY=$WANT"
exit 0
