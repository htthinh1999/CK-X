#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod secure-net -n bolt >/dev/null 2>&1; then
  echo "Success: pod secure-net exists"; exit 0
fi
echo "Error: pod secure-net not found in bolt"; exit 1
