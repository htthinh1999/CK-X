#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get cronjob nightly-backup -n twilight >/dev/null 2>&1; then
  echo "Success: cronjob nightly-backup exists in twilight"
  exit 0
else
  echo "Error: cronjob nightly-backup not found in twilight"
  exit 1
fi
