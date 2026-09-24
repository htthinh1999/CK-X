#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
k=$(kubectl get secret web-tls -n flare -o jsonpath='{.data.tls\.key}' 2>/dev/null)
if [ -n "$k" ]; then
  echo "Success: has tls.key"
  exit 0
else
  echo "Error: missing tls.key key"
  exit 1
fi
