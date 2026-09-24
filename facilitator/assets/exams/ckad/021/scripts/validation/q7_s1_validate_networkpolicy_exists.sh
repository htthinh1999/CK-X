#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy db-protect -n bastion >/dev/null 2>&1; then
  echo "Success: networkpolicy db-protect exists in bastion"
  exit 0
fi
echo "Error: networkpolicy db-protect missing in bastion"
exit 1
