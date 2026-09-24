#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment my-app -n mastery >/dev/null 2>&1; then
  echo "Success: deployment my-app applied in mastery"
  exit 0
fi
echo "Error: deployment my-app not found in mastery"
exit 1
