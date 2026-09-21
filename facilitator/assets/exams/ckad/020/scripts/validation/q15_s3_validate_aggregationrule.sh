#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get clusterrole aggregated-monitor >/dev/null 2>&1; then
  echo "Error: clusterrole aggregated-monitor not found"
  exit 1
fi
agg=$(kubectl get clusterrole aggregated-monitor -o jsonpath='{.aggregationRule}' 2>/dev/null)
if [ -n "$agg" ] && [ "$agg" != "map[]" ] && [ "$agg" != "{}" ]; then
  echo "Success: aggregated-monitor has an aggregationRule"
  exit 0
fi
echo "Error: aggregated-monitor has no aggregationRule"
exit 1
