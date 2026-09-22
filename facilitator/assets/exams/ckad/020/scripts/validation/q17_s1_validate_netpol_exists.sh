#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy allow-named-port -n matrix >/dev/null 2>&1; then
  echo "Success: networkpolicy allow-named-port exists in matrix"
  exit 0
fi
echo "Error: networkpolicy allow-named-port not found in matrix"
exit 1
