#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
t=$(kubectl get deployment spread-deploy -n blaze -o jsonpath='{.spec.template.spec.topologySpreadConstraints}' 2>/dev/null)
if [ -n "$t" ]; then
  echo "Success: topologySpreadConstraints present"
  exit 0
else
  echo "Error: topologySpreadConstraints not found"
  exit 1
fi
