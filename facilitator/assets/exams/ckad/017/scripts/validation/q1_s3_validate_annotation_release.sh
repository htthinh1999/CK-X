#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deploy app-deploy -n trench -o jsonpath='{.metadata.annotations.release}' 2>/dev/null)
if [ "$v" = "v1.0.0" ]; then
  echo "Success: annotation release=v1.0.0 applied"; exit 0
fi
echo "Error: annotation release is '$v', expected v1.0.0"; exit 1
