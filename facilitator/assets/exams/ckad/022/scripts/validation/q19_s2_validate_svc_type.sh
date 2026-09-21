#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
type=$(kubectl get svc ascend-svc -n ascend -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$type" = "NodePort" ]; then
  echo "Success: service ascend-svc is NodePort"
  exit 0
fi
echo "Error: service type is '$type', expected NodePort"
exit 1
