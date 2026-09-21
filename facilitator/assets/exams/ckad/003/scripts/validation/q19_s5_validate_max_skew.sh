#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
m=$(kubectl get deployment spread-deploy -n blaze -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].maxSkew}' 2>/dev/null)
if [ "$m" = "1" ]; then
  echo "Success: maxSkew 1"
  exit 0
else
  echo "Error: maxSkew is '$m', expected 1"
  exit 1
fi
