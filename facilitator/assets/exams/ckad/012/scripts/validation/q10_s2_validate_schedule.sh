#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get cronjob cleanup-job -n stronghold -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$val" = "*/5 * * * *" ]; then
  echo "Success: Schedule ($val)"
  exit 0
else
  echo "Error: Schedule - got '$val', expected '*/5 * * * *'"
  exit 1
fi
