#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
st=$(kubectl get pod crash-app -n ember -o jsonpath='{.status.containerStatuses[0].state.running.startedAt}' 2>/dev/null)
if [ -n "$st" ]; then
  echo "Success: pod is currently running"
  exit 0
else
  echo "Error: pod is not in running state"
  exit 1
fi
