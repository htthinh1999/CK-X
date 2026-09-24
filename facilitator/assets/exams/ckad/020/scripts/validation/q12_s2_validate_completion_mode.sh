#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mode=$(kubectl get job index-processor -n primal -o jsonpath='{.spec.completionMode}' 2>/dev/null)
if [ "$mode" = "Indexed" ]; then
  echo "Success: completionMode is Indexed"
  exit 0
fi
echo "Error: completionMode is '$mode', expected Indexed"
exit 1
