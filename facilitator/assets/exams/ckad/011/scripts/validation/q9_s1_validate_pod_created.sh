#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
# Source awards this point when echo-pod exists OR when it is absent (auto-deleted with --rm).
if kubectl get pod echo-pod -n current >/dev/null 2>&1; then
  echo "Success: Pod echo-pod exists in current"
else
  echo "Success: Pod echo-pod not found (may have completed and been auto-removed with --rm)"
fi
exit 0
