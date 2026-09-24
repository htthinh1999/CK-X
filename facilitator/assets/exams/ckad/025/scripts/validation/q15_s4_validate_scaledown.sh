#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=tracker; HPA=satpos-hpa

win=$(kubectl -n "$NS" get horizontalpodautoscalers.v2.autoscaling "$HPA" -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}' 2>/dev/null)

if [ "$win" = "180" ]; then
  echo "PASS: scaleDown stabilizationWindowSeconds is 180"
  exit 0
fi
echo "FAIL: expected behavior.scaleDown.stabilizationWindowSeconds=180, got '$win'"
exit 1
