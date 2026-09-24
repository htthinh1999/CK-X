#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get service web-svc -n flame -o jsonpath='{.spec.ports[?(@.port==443)].port}' 2>/dev/null)
if [ "$p" = "443" ]; then
  echo "Success: exposes port 443"
  exit 0
else
  echo "Error: port 443 not exposed"
  exit 1
fi
