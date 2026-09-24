#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get deployment nginx-deploy -n valley -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}' 2>/dev/null)
if [ "$v" = "80" ]; then
  echo "Success: container port is 80"; exit 0
else
  echo "Error: container port is '$v', expected 80"; exit 1
fi
