#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
anno=$(kubectl get ingress regex-ingress -n bulwark -o jsonpath='{.metadata.annotations}' 2>/dev/null)
if [[ "$anno" == *"use-regex"* ]]; then
  echo "Success: use-regex annotation present"
  exit 0
fi
echo "Error: use-regex annotation missing"
exit 1
