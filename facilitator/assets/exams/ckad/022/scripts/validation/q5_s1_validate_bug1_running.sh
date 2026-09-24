#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
phase=$(kubectl get pod bug-1 -n ascend -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$phase" = "Running" ]; then
  echo "Success: bug-1 is Running"
  exit 0
fi
echo "Error: bug-1 phase is '$phase', expected Running"
exit 1
