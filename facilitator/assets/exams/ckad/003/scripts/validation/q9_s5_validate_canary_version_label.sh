#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment canary-v2 -n blaze -o jsonpath='{.spec.template.metadata.labels.version}' 2>/dev/null)
if [ "$v" = "v2" ]; then
  echo "Success: version=v2 label"
  exit 0
else
  echo "Error: version label is '$v', expected v2"
  exit 1
fi
