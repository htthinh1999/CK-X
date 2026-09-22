#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get secret web-tls -n flare >/dev/null 2>&1; then
  echo "Success: secret web-tls exists"
  exit 0
else
  echo "Error: secret web-tls not found"
  exit 1
fi
