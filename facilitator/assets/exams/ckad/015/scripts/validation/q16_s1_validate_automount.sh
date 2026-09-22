#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get pod zephyr-api -n zephyr >/dev/null 2>&1 || { echo "Error: Pod zephyr-api not found in zephyr"; exit 1; }
auto=$(kubectl get pod zephyr-api -n zephyr -o jsonpath='{.spec.automountServiceAccountToken}' 2>/dev/null)
if [ "$auto" == "false" ]; then
  echo "Success: automountServiceAccountToken is false"
  exit 0
else
  echo "Error: automountServiceAccountToken='$auto' (expected false)"
  exit 1
fi
