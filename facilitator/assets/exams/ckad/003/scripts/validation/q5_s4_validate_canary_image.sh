#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
image=$(kubectl get deployment canary-v2 -n blaze -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if echo "$image" | grep -q "nginx:1.22"; then
  echo "Success: canary uses nginx:1.22"
  exit 0
else
  echo "Error: canary image is '$image', expected nginx:1.22"
  exit 1
fi
