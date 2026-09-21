#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c=$(kubectl get secret web-tls -n flare -o jsonpath='{.data.tls\.crt}' 2>/dev/null)
if [ -n "$c" ]; then
  echo "Success: has tls.crt"
  exit 0
else
  echo "Error: missing tls.crt key"
  exit 1
fi
