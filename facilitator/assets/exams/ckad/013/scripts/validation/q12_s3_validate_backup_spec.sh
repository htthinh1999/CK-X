#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl get backup daily-backup -n aurora -o jsonpath='{.spec.schedule}' 2>/dev/null)
r=$(kubectl get backup daily-backup -n aurora -o jsonpath='{.spec.retentionDays}' 2>/dev/null)
if [ "$s" = "0 2 * * *" ] && [ "$r" = "30" ]; then
  echo "Success: backup spec correct"
  exit 0
else
  echo "Error: schedule='$s' retentionDays='$r'"
  exit 1
fi
