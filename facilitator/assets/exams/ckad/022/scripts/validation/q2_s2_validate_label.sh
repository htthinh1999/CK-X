#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
labels=$(kubectl get deployment my-app -n mastery -o jsonpath='{.metadata.labels.env}' 2>/dev/null)
if [ "$labels" = "prod" ]; then
  echo "Success: label env=prod applied by Kustomize"
  exit 0
fi
echo "Error: label env is '$labels', expected prod"
exit 1
