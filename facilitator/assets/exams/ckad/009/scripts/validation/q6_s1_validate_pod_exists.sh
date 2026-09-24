#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod web -n thicket >/dev/null 2>&1; then
  echo "Success: pod web exists in thicket"; exit 0
else
  echo "Error: pod web not found in thicket"; exit 1
fi
