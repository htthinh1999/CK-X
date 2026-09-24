#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

ref=$(kubectl get pod api-pod -n moss -o jsonpath='{.spec.containers[0].env[0].valueFrom.secretKeyRef.name}' 2>/dev/null)
if [ "$ref" = "api-secret" ]; then
  echo "Success: secret env configured correctly"; exit 0
else
  echo "Error: secretKeyRef name is '$ref', expected api-secret"; exit 1
fi
