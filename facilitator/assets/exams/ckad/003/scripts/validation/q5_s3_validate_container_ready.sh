#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get pod crash-app -n ember -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null)
if [ "$r" = "true" ]; then
  echo "Success: container ready"
  exit 0
else
  echo "Error: container ready is '$r', expected true"
  exit 1
fi
