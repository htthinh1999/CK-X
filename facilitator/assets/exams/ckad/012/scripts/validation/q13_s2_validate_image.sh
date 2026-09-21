#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment web-server -n citadel -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$val" = "nginx:1.25" ]; then
  echo "Success: Image rolled back ($val)"
  exit 0
else
  echo "Error: Image rolled back - got '$val', expected 'nginx:1.25'"
  exit 1
fi
