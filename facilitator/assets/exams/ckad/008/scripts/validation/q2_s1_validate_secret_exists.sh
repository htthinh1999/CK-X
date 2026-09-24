#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get secret mysecret -n ridge >/dev/null 2>&1; then
  echo "Success: secret mysecret exists"; exit 0
else
  echo "Error: secret mysecret not found"; exit 1
fi
