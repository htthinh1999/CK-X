#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if ! kubectl get svc mesh-service -n wave >/dev/null 2>&1; then
  echo "Error: service mesh-service not found in wave"; exit 1
fi
ep=$(kubectl get endpoints mesh-service -n wave -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)
if [ -n "$ep" ]; then
  echo "Success: mesh-service has active endpoint $ep"; exit 0
fi
echo "Error: mesh-service has no endpoints"; exit 1
