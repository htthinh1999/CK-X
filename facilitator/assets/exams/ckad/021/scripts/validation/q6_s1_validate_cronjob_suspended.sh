#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sus=$(kubectl get cronjob backup-cj -n shield -o jsonpath='{.spec.suspend}' 2>/dev/null)
if [[ "$sus" == "true" ]]; then
  echo "Success: cronjob backup-cj suspended"
  exit 0
fi
echo "Error: cronjob backup-cj not suspended (suspend=$sus)"
exit 1
