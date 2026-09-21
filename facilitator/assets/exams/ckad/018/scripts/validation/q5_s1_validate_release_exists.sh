#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if helm ls -n chorus 2>/dev/null | grep -q wisdom-app; then
  echo "Success: helm release wisdom-app exists in chorus"; exit 0
fi
echo "Error: helm release wisdom-app not found in chorus"; exit 1
