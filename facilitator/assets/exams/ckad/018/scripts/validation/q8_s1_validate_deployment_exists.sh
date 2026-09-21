#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment app-deploy -n lyric >/dev/null 2>&1; then
  echo "Success: deployment app-deploy exists in lyric"; exit 0
fi
echo "Error: deployment app-deploy not found in lyric"; exit 1
