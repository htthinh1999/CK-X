#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get service web-svc -n flame -o jsonpath='{.spec.ports[?(@.port==80)].port}' 2>/dev/null)
if [ "$p" = "80" ]; then
  echo "Success: exposes port 80"
  exit 0
else
  echo "Error: port 80 not exposed"
  exit 1
fi
