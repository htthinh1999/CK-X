#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get job manual-backup -n shield >/dev/null 2>&1; then
  echo "Success: job manual-backup exists in shield"
  exit 0
fi
echo "Error: job manual-backup missing in shield"
exit 1
