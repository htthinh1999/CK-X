#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
image=$(kubectl get job data-processor -n spark -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if echo "$image" | grep -q "busybox"; then
  echo "Success: uses busybox"
  exit 0
else
  echo "Error: image is '$image', expected busybox"
  exit 1
fi
