#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment health-app -n tower -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.port}' 2>/dev/null)
if [ "$val" = "80" ]; then
  echo "Success: Liveness probe port ($val)"
  exit 0
else
  echo "Error: Liveness probe port - got '$val', expected '80'"
  exit 1
fi
