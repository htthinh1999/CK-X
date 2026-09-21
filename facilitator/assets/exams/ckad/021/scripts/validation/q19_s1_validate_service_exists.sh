#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service topology-service -n anchor >/dev/null 2>&1; then
  echo "Success: service topology-service exists in anchor"
  exit 0
fi
echo "Error: service topology-service missing in anchor"
exit 1
