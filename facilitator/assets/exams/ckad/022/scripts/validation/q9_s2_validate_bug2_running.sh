#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
phase=$(kubectl get pod bug-2 -n ascend -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$phase" = "Running" ]; then
  echo "Success: bug-2 is Running"
  exit 0
fi
echo "Error: bug-2 phase is '$phase', expected Running"
exit 1
