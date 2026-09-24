#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment my-app -n bulwark >/dev/null 2>&1; then
  echo "Success: deployment my-app exists in bulwark"
  exit 0
fi
echo "Error: deployment my-app missing in bulwark"
exit 1
