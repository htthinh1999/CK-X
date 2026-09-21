#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
img=$(helm get values guardian-app -n haven -o json 2>/dev/null | grep tag)
if [[ "$img" == *"latest"* ]]; then
  echo "Success: image tag is latest"
  exit 0
fi
echo "Error: image tag not latest ($img)"
exit 1
