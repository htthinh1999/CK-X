#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get svc backend -n rice -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
if [ "$val" = "8080" ]; then
  echo "Success: service backend targetPort is 8080"
  exit 0
else
  echo "Error: service backend targetPort incorrect (got '$val')"
  exit 1
fi
