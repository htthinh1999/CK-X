#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
img=$(kubectl get deploy api-server -n lagoon -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$img" = "nginx:1.24" ]; then
  echo "Success: deployment rolled back to nginx:1.24"; exit 0
fi
echo "Error: image is '$img', expected nginx:1.24"; exit 1
