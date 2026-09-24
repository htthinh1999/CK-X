#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
image=$(kubectl get deployment glory-deploy -n glory -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$image" = "nginx:1.25" ] || [ "$image" = "nginx" ]; then
  echo "Success: image is '$image'"
  exit 0
fi
echo "Error: image is '$image', expected nginx:1.25 or nginx"
exit 1
