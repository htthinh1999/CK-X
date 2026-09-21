#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod annotated-pod -n prosperity -o jsonpath='{.metadata.annotations.owner}' 2>/dev/null)
if [ "$val" = "marketing" ]; then
  echo "Success: annotation owner=marketing correct"
  exit 0
else
  echo "Error: annotation owner incorrect (got '$val')"
  exit 1
fi
