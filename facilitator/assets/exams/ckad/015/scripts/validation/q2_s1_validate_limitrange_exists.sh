#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get limitrange cyclone-limits -n cyclone >/dev/null 2>&1; then
  echo "Success: LimitRange cyclone-limits exists in cyclone"
  exit 0
else
  echo "Error: LimitRange cyclone-limits not found in cyclone"
  exit 1
fi
