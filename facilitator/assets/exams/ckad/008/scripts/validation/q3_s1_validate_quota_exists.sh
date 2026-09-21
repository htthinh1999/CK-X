#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get resourcequota cliff-quota -n cliff >/dev/null 2>&1; then
  echo "Success: resourcequota cliff-quota exists"; exit 0
else
  echo "Error: resourcequota cliff-quota not found"; exit 1
fi
