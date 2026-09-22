#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

img=$(kubectl get deployment pause-deploy -n bark -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [[ "$img" == *"nginx:1.19"* ]]; then
  echo "Success: image updated to nginx:1.19"; exit 0
else
  echo "Error: image is '$img', expected nginx:1.19"; exit 1
fi
