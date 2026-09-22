#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
t=$(kubectl get service web-svc -n flame -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$t" = "ClusterIP" ]; then
  echo "Success: type ClusterIP"
  exit 0
else
  echo "Error: type is '$t', expected ClusterIP"
  exit 1
fi
