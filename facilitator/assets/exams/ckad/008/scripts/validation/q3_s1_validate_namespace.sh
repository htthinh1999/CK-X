#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get namespace mynamespace >/dev/null 2>&1; then
  echo "Success: namespace mynamespace exists"; exit 0
else
  echo "Error: namespace mynamespace not found"; exit 1
fi
