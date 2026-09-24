#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
phase=$(kubectl get pod bug-3 -n ascend -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$phase" = "Running" ]; then
  echo "Success: bug-3 is Running"
  exit 0
fi
echo "Error: bug-3 phase is '$phase', expected Running"
exit 1
