#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ip=$(kubectl get service backend-headless -n corona -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
if [ "$ip" = "None" ]; then
  echo "Success: clusterIP None"
  exit 0
else
  echo "Error: clusterIP is '$ip', expected None"
  exit 1
fi
