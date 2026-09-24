#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=calibration
DEP=lens-calibrator

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in namespace $NS"; exit 1; }

if echo "$json" | jq -e '[.spec.template.spec.volumes[]? | select(.configMap.name == "optics-v1")] | length > 0' >/dev/null; then
  echo "FAIL: Deployment $DEP still references ConfigMap optics-v1"
  exit 1
fi

echo "$json" | jq -e '
  .spec.template.spec as $s
  | [ $s.volumes[]? | select(.configMap.name == "optics-v2") | .name ] as $v
  | [ $s.containers[].volumeMounts[]?
      | select((.mountPath | rtrimstr("/")) == "/etc/lens")
      | .name as $m
      | select(any($v[]; . == $m)) ]
  | length > 0' >/dev/null \
  || { echo "FAIL: no volume from ConfigMap optics-v2 is mounted at /etc/lens"; exit 1; }

echo "OK: Deployment $DEP mounts ConfigMap optics-v2 at /etc/lens"
exit 0
