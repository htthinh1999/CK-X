#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cnt=$(kubectl get pods -n harvest -l env=prod -o name 2>/dev/null | wc -l)
if [ "$cnt" -ge 2 ] 2>/dev/null; then
  echo "Success: pods with env=prod exist ($cnt pods)"
  exit 0
else
  echo "Error: not enough pods with env=prod ($cnt pods)"
  exit 1
fi
