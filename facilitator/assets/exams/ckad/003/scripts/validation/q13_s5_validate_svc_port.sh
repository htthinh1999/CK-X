#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get service -n flare -l app.kubernetes.io/instance=phoenix-api -o jsonpath='{.items[0].spec.ports[0].port}' 2>/dev/null)
if [ "$p" = "8080" ]; then
  echo "Success: service port 8080"
  exit 0
else
  echo "Error: service port is '$p', expected 8080"
  exit 1
fi
