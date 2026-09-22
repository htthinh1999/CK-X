#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get ingress api-ingress -n citadel -o jsonpath='{.spec.rules[0].http.paths[0].path}' 2>/dev/null)
if [ "$val" = "/app" ]; then
  echo "Success: Path ($val)"
  exit 0
else
  echo "Error: Path - got '$val', expected '/app'"
  exit 1
fi
