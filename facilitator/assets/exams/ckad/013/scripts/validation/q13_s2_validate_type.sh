#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
t=$(kubectl get secret web-tls -n flare -o jsonpath='{.type}' 2>/dev/null)
if [ "$t" = "kubernetes.io/tls" ]; then
  echo "Success: type kubernetes.io/tls"
  exit 0
else
  echo "Error: type is '$t'"
  exit 1
fi
