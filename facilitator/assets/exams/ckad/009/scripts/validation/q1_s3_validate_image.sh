#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

img=$(kubectl get deployment app-deploy -n root -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [[ "$img" == *"nginx:1.18"* ]]; then
  echo "Success: image nginx:1.18 correct"; exit 0
else
  echo "Error: image is '$img', expected nginx:1.18"; exit 1
fi
