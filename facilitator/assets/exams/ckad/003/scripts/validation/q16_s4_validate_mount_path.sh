#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mp=$(kubectl get pod token-pod -n magma -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}' 2>/dev/null)
if echo "$mp" | grep -q "fire-token"; then
  echo "Success: token mounted under fire-token path"
  exit 0
else
  echo "Error: no volumeMount path contains fire-token"
  exit 1
fi
