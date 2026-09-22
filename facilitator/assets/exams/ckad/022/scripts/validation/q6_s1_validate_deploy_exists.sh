#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment glory-deploy -n glory >/dev/null 2>&1; then
  echo "Success: deployment glory-deploy exists in glory"
  exit 0
fi
echo "Error: deployment glory-deploy not found in glory"
exit 1
