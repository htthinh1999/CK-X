#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
schedule=$(kubectl get cronjob db-backup -n zenith -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$schedule" = "*/15 * * * *" ]; then
  echo "Success: schedule is */15 * * * *"
  exit 0
fi
echo "Error: schedule is '$schedule', expected */15 * * * *"
exit 1
