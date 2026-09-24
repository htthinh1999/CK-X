#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod arg-reader -n voltage >/dev/null 2>&1; then
  echo "Success: pod arg-reader exists"; exit 0
fi
echo "Error: pod arg-reader not found in voltage"; exit 1
