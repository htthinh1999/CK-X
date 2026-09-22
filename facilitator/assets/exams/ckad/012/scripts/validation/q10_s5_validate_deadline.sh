#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get cronjob cleanup-job -n stronghold -o jsonpath='{.spec.jobTemplate.spec.activeDeadlineSeconds}' 2>/dev/null)
if [ "$val" = "30" ]; then
  echo "Success: activeDeadlineSeconds ($val)"
  exit 0
else
  echo "Error: activeDeadlineSeconds - got '$val', expected '30'"
  exit 1
fi
