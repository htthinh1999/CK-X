#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if ! kubectl get role config-editor -n haven >/dev/null 2>&1; then
  echo "Error: role config-editor missing in haven"
  exit 1
fi
rnames=$(kubectl get role config-editor -n haven -o jsonpath='{.rules[0].resourceNames}' 2>/dev/null)
if [[ "$rnames" == *"primary-config"* ]]; then
  echo "Success: role targets resourceNames ($rnames)"
  exit 0
fi
echo "Error: role missing resourceNames primary-config ($rnames)"
exit 1
