#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
img=$(kubectl get pod backend-pod -n wave -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ "$img" = "nginx:alpine" ]; then
  echo "Success: image corrected to nginx:alpine"; exit 0
fi
echo "Error: image is '$img', expected nginx:alpine"; exit 1
