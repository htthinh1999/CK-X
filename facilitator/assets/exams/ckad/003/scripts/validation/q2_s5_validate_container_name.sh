#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cn=$(kubectl get deployment fire-app -n blaze -o jsonpath='{.spec.template.spec.containers[0].name}' 2>/dev/null)
if [ "$cn" = "fire-container" ]; then
  echo "Success: container is fire-container"
  exit 0
else
  echo "Error: container is '$cn', expected fire-container"
  exit 1
fi
