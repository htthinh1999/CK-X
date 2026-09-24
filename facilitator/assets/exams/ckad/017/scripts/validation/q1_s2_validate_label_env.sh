#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deploy app-deploy -n trench -o jsonpath='{.metadata.labels.env}' 2>/dev/null)
if [ "$v" = "production" ]; then
  echo "Success: label env=production applied"; exit 0
fi
echo "Error: label env is '$v', expected production"; exit 1
