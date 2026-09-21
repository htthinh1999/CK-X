#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod monitored-pod -n ward >/dev/null 2>&1; then
  echo "Success: pod monitored-pod exists in ward"
  exit 0
fi
echo "Error: pod monitored-pod missing in ward"
exit 1
