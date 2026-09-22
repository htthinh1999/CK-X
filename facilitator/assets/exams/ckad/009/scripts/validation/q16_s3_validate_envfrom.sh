#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

ref=$(kubectl get pod env-pod -n meadow -o jsonpath='{.spec.containers[0].envFrom[0].configMapRef.name}' 2>/dev/null)
if [ "$ref" = "env-config" ]; then
  echo "Success: envFrom configMapRef env-config configured"; exit 0
else
  echo "Error: envFrom configMapRef is '$ref', expected env-config"; exit 1
fi
