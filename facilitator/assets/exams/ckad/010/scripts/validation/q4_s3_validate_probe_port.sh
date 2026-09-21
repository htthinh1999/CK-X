#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod ready-pod -n field -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.port}' 2>/dev/null)
if [ "$val" = "80" ]; then
  echo "Success: readiness probe port is 80"
  exit 0
else
  echo "Error: readiness probe port incorrect (got '$val')"
  exit 1
fi
