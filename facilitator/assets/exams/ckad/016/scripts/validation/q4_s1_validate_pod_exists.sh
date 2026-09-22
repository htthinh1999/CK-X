#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod app-with-wait -n storm >/dev/null 2>&1; then
  echo "Success: pod app-with-wait exists"; exit 0
fi
echo "Error: pod app-with-wait not found in storm"; exit 1
