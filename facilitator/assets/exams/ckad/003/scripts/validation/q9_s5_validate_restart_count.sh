#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rc=$(kubectl get pod crash-app -n ember -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null)
if [ -n "$rc" ] && [ "$rc" -lt 5 ] 2>/dev/null; then
  echo "Success: restart count $rc (<5)"
  exit 0
else
  echo "Error: restart count is '$rc', expected <5"
  exit 1
fi
