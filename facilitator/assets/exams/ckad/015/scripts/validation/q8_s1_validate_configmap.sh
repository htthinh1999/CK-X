#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cm=$(kubectl get cm -n tornado -o name 2>/dev/null | grep tornado-config | head -n 1)
if [ -n "$cm" ]; then
  echo "Success: ConfigMap tornado-config exists in tornado ($cm)"
  exit 0
else
  echo "Error: ConfigMap tornado-config not found in tornado"
  exit 1
fi
