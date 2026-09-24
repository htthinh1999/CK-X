#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
nginx_img=$(kubectl get deployment worker-deploy -n bastion -o jsonpath='{.spec.template.spec.containers[?(@.name=="nginx")].image}' 2>/dev/null)
if [[ "$nginx_img" == "nginx:1.24.0" ]]; then
  echo "Success: nginx image is nginx:1.24.0 (rollback OK)"
  exit 0
fi
echo "Error: nginx image is '$nginx_img', expected nginx:1.24.0"
exit 1
