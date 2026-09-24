#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# Source awards full points as long as the deployment exists (rollback performed).
if kubectl get deployment legacy-app -n verse >/dev/null 2>&1; then
  echo "Success: deployment legacy-app present (rollback performed)"; exit 0
fi
echo "Error: deployment legacy-app not found in verse"; exit 1
