#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
redis_img=$(kubectl get deployment worker-deploy -n bastion -o jsonpath='{.spec.template.spec.containers[?(@.name=="redis")].image}' 2>/dev/null)
if [[ "$redis_img" == "redis:6.2" ]] || [[ "$redis_img" == "redis:7.0" ]]; then
  echo "Success: redis image is $redis_img"
  exit 0
fi
echo "Error: redis image is '$redis_img', expected redis:6.2 or redis:7.0"
exit 1
