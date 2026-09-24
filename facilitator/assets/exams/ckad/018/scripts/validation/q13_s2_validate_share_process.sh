#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
share=$(kubectl get pod shared-process-pod -n cadence -o jsonpath='{.spec.shareProcessNamespace}' 2>/dev/null)
if [ "$share" == "true" ]; then
  echo "Success: shareProcessNamespace enabled"; exit 0
fi
echo "Error: shareProcessNamespace is '$share', expected true"; exit 1
