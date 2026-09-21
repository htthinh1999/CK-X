#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get resourcequota compute-quota -n nightfall >/dev/null 2>&1; then
  echo "Success: resourcequota compute-quota exists in nightfall"
  exit 0
else
  echo "Error: resourcequota compute-quota not found in nightfall"
  exit 1
fi
