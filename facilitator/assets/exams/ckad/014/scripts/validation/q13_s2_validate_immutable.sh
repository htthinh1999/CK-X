#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
imm=$(kubectl get cm static-config -n twilight -o jsonpath='{.immutable}' 2>/dev/null)
if [ "$imm" == "true" ]; then
  echo "Success: configmap static-config is immutable"
  exit 0
else
  echo "Error: configmap is not immutable (immutable='$imm')"
  exit 1
fi
