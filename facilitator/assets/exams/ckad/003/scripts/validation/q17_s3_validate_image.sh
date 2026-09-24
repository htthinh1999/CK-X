#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
image=$(kubectl get pod lifecycle-pod -n phoenix -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ "$image" = "nginx:1.21" ]; then
  echo "Success: image nginx:1.21"
  exit 0
else
  echo "Error: image is '$image', expected nginx:1.21"
  exit 1
fi
