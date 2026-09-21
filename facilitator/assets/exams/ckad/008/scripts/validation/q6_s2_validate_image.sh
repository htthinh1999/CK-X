#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

v=$(kubectl get deployment nginx-deploy -n valley -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$v" = "nginx:1.19.8" ]; then
  echo "Success: image is nginx:1.19.8"; exit 0
else
  echo "Error: image is '$v', expected nginx:1.19.8"; exit 1
fi
