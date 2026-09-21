#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
i=$(kubectl get deploy api-app -n dawn -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$i" = "nginx:1.26" ]; then
  echo "Success: image nginx:1.26"
  exit 0
else
  echo "Error: image is '$i' (expected nginx:1.26)"
  exit 1
fi
