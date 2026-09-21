#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
img=$(kubectl get pod data-processor -n crescent -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ "$img" == "nginx:alpine" ]; then
  echo "Success: main container image is nginx:alpine"
  exit 0
else
  echo "Error: main container image is '$img', expected nginx:alpine"
  exit 1
fi
