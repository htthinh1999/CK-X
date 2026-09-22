#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
img=$(kubectl get deployment broken-app -n anchor -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [[ "$img" == "nginx:1.25.0" ]]; then
  echo "Success: image corrected to nginx:1.25.0"
  exit 0
fi
echo "Error: image is '$img', expected nginx:1.25.0"
exit 1
