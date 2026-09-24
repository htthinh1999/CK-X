#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if ! kubectl get configmap binary-config -n rhythm >/dev/null 2>&1; then
  echo "Error: configmap binary-config not found in rhythm"; exit 1
fi
bin=$(kubectl get cm binary-config -n rhythm -o jsonpath='{.binaryData}' 2>/dev/null)
if [[ -n "$bin" ]]; then
  echo "Success: configmap binary-config has binary data"; exit 0
fi
echo "Error: configmap binary-config has no binaryData"; exit 1
