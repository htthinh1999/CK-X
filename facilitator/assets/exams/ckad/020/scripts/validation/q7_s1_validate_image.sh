#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
img=$(kubectl get deployment eden-api -n eden -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$img" = "nginx:1.21" ]; then
  echo "Success: eden-api image is nginx:1.21"
  exit 0
fi
echo "Error: eden-api image is '$img', expected nginx:1.21"
exit 1
