#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
img=$(kubectl get pod entry-override -n fortress -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
[ "$img" = "nginx:alpine" ] && { echo "Success: image is nginx:alpine"; exit 0; }
echo "Error: image is '$img', expected nginx:alpine"; exit 1
