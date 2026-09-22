#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get svc backend -n rice -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$val" = "6262" ]; then
  echo "Success: service backend port is 6262"
  exit 0
else
  echo "Error: service backend port incorrect (got '$val')"
  exit 1
fi
