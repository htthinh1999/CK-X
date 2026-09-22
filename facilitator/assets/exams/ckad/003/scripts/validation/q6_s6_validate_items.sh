#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
items=$(kubectl get pod config-reader -n flame -o jsonpath='{.spec.volumes[0].configMap.items}' 2>/dev/null)
if [ -n "$items" ]; then
  echo "Success: items specified"
  exit 0
else
  echo "Error: configMap items not specified"
  exit 1
fi
