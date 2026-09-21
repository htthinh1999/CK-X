#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod shared-pod -n bounty -o jsonpath='{.spec.volumes[?(@.name=="shared-data")].emptyDir}' 2>/dev/null)
if [ "$val" = "{}" ]; then
  echo "Success: emptyDir volume shared-data configured"
  exit 0
else
  echo "Error: emptyDir volume shared-data missing (got '$val')"
  exit 1
fi
