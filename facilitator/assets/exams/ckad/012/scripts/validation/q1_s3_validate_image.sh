#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
img=$(kubectl get deployment canary-app -n bulwark -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
case "$img" in
  *nginx:1.25*) echo "Success: image is $img"; exit 0;;
  *) echo "Error: image is '$img', expected nginx:1.25"; exit 1;;
esac
