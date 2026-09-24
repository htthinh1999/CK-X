#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
labels=$(kubectl get deployment legacy-canary -n legacy -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ "$labels" = "legacy-web" ]; then
  echo "Success: pod template label app=legacy-web"
  exit 0
fi
echo "Error: label app is '$labels', expected legacy-web"
exit 1
