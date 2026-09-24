#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod ready-pod -n field -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null)
if [ "$val" = "/" ]; then
  echo "Success: readiness probe path is /"
  exit 0
else
  echo "Error: readiness probe path incorrect (got '$val')"
  exit 1
fi
