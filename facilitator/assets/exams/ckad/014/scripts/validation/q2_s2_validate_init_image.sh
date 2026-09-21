#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
img=$(kubectl get pod data-processor -n crescent -o jsonpath='{.spec.initContainers[0].image}' 2>/dev/null)
if [ "$img" == "busybox:1.36" ]; then
  echo "Success: init container image is busybox:1.36"
  exit 0
else
  echo "Error: init container image is '$img', expected busybox:1.36"
  exit 1
fi
