#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if helm ls -n crown 2>/dev/null | grep -q "crown-release"; then
  echo "Success: helm release crown-release found in crown"
  exit 0
fi
echo "Error: helm release crown-release not found in crown"
exit 1
